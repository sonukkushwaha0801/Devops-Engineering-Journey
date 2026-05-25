# =========================
# Security Groups using for_each
# =========================

resource "aws_security_group" "dynamic_sg" {
  for_each    = toset(var.security_groups)
  name        = each.value
  description = "Managed by Terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = each.value
    ManagedBy = "terraform"
  }
}

# =========================
# EC2 Instances using count
# =========================

resource "aws_instance" "frontend" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    values(aws_security_group.dynamic_sg)[0].id
  ]

  tags = {
    Name        = "frontend-server-${count.index + 1}"
    Environment = "practice"
    ManagedBy   = "terraform"
  }
}
