terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary Region Provider
provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

# Secondary Region Provider
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

# ==========================================
# Primary Region Module
# ==========================================

module "primary_region" {
  source = "./modules/regional-deployment"

  providers = {
    aws = aws.primary
  }

  region             = var.primary_region
  environment        = var.environment
  instance_count     = var.primary_instance_count
  instance_type      = var.instance_type
  rds_instance_class = var.rds_instance_class
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  is_primary         = true

  tags = {
    Role   = "Primary"
    Region = var.primary_region
  }
}

# ==========================================
# Secondary Region Module (Read Replica)
# ==========================================

module "secondary_region" {
  source = "./modules/regional-deployment"

  providers = {
    aws = aws.secondary
  }

  depends_on = [module.primary_region]

  region             = var.secondary_region
  environment        = var.environment
  instance_count     = var.secondary_instance_count
  instance_type      = var.instance_type
  rds_instance_class = var.rds_instance_class
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  is_primary         = false

  # Reference primary region resources for replication
  primary_rds_endpoint = module.primary_region.rds_endpoint

  tags = {
    Role   = "Secondary"
    Region = var.secondary_region
  }
}

# ==========================================
# Route 53 Configuration (Global)
# ==========================================

resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name = "multi-region-zone"
  }
}

# Primary region endpoint
resource "aws_route53_record" "primary_endpoint" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  set_identifier = "primary-${var.primary_region}"

  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = module.primary_region.load_balancer_dns
    zone_id                = module.primary_region.load_balancer_zone_id
    evaluate_target_health = true
  }
}

# Secondary region endpoint (failover)
resource "aws_route53_record" "secondary_endpoint" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  set_identifier = "secondary-${var.secondary_region}"

  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name                   = module.secondary_region.load_balancer_dns
    zone_id                = module.secondary_region.load_balancer_zone_id
    evaluate_target_health = true
  }
}

# ==========================================
# Cross-Region S3 Replication (Optional)
# ==========================================

resource "aws_s3_bucket" "primary_bucket" {
  provider = aws.primary
  bucket   = "app-bucket-${var.primary_region}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_replication_configuration" "main" {
  provider   = aws.primary
  depends_on = [aws_s3_bucket.secondary_bucket]

  bucket = aws_s3_bucket.primary_bucket.id

  role = aws_iam_role.s3_replication.arn

  rule {
    status = "Enabled"
    id     = "replicate-all"

    filter {
      prefix = ""
    }

    destination {
      bucket        = "arn:aws:s3:::app-bucket-${var.secondary_region}-${data.aws_caller_identity.current.account_id}"
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket" "secondary_bucket" {
  provider = aws.secondary
  bucket   = "app-bucket-${var.secondary_region}-${data.aws_caller_identity.current.account_id}"
}

# ==========================================
# IAM Role for S3 Replication
# ==========================================

resource "aws_iam_role" "s3_replication" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_replication" {
  name = "s3-replication-policy"
  role = aws_iam_role.s3_replication.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.primary_bucket.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl"
        ]
        Resource = "${aws_s3_bucket.primary_bucket.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ]
        Resource = "${aws_s3_bucket.secondary_bucket.arn}/*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
