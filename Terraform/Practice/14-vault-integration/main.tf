# ==========================================
# PART 2: Read secrets from Vault Server
# ==========================================

# Data source to read secrets from Vault
data "vault_generic_secret" "db_credentials" {
  path = "secret/data/database/mysql"

  depends_on = [null_resource.wait_for_vault]
}

# ==========================================
# Extract secret values for use in resources
# ==========================================

locals {
  db_username = try(data.vault_generic_secret.db_credentials.data.data.username, "admin")
  db_password = try(data.vault_generic_secret.db_credentials.data.data.password, random_password.default.result)
  db_host     = try(data.vault_generic_secret.db_credentials.data.data.host, "localhost")
}

# Fallback password if Vault secret not found
resource "random_password" "default" {
  length  = 16
  special = true
}

# ==========================================
# RDS Database (Example)
# ==========================================

# ==========================================
# RDS Database (Uses Vault secrets)
# ==========================================

resource "aws_db_subnet_group" "main" {
  count      = var.enable_rds_database ? 1 : 0
  name       = "vault-demo-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "vault-demo-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  count       = var.enable_rds_database ? 1 : 0
  name        = "vault-demo-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vault-demo-rds-sg"
  }
}

resource "aws_db_instance" "main" {
  count             = var.enable_rds_database ? 1 : 0
  identifier        = "vault-demo-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "vaultdemo"
  username = local.db_username
  password = local.db_password

  db_subnet_group_name   = aws_db_subnet_group.main[0].name
  vpc_security_group_ids = [aws_security_group.rds[0].id]

  skip_final_snapshot     = true
  publicly_accessible     = false
  backup_retention_period = 7
  multi_az                = false

  tags = {
    Name = "vault-demo-database"
  }

  depends_on = [
    aws_db_subnet_group.main,
    null_resource.wait_for_vault
  ]
}

# ==========================================
# VPC (Required for RDS)
# ==========================================

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vault-demo-vpc"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "vault-demo-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "vault-demo-private-2"
  }
}
