resource "aws_instance" "frontend" {
  ami           = var.ami_id
  key_name      = var.key_pair
  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    ManagedBy   = "terraform"
    Environment = "practice"
  }
}
