# =========================
# Security Group
# =========================

resource "aws_security_group" "frontend_sg" {
  name        = "terraform-remote-backend-sg"
  description = "Allow SSH Access"

  ingress {
    description = "SSH Access"
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
    Name        = "terraform-remote-backend-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# =========================
# EC2 Instance
# =========================

resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [
    aws_security_group.frontend_sg.id
  ]

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
