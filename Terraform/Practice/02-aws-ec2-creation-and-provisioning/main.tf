resource "aws_instance" "frontend" {
  ami = var.ami_id

  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    Environment = "practice"
    ManagedBy   = "terraform"
  }
}
