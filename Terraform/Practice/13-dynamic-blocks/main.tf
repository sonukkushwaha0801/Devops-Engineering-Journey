# =========================
# Security Group
# =========================

resource "aws_security_group" "dynamic_sg" {
  name        = "terraform-dynamic-blocks-sg"
  description = "Dynamic ingress rules"

  # =========================
  # Dynamic Ingress Rules
  # =========================

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow Port ${ingress.value}"
    }
  }

  # =========================
  # Egress Rules
  # =========================
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "terraform-dynamic-blocks-sg"
    ManagedBy = "terraform"
  }
}

# =========================
# EC2 Instance
# =========================

resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.dynamic_sg.id
  ]

  tags = {
    Name        = "dynamic-blocks-server"
    Environment = "practice"
    ManagedBy   = "terraform"
  }
}
