resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair
  tags = {
    Name        = var.instance_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
