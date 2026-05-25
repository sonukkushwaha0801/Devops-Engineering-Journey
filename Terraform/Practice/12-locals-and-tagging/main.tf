# =========================
# Security Group
# =========================

resource "aws_security_group" "frontend_sg" {
  name        = "${local.name_prefix}-sg"
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

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-sg"
    }
  )
}

# =========================
# EC2 Instance
# =========================

resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.frontend_sg.id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-server"
    }
  )
}
