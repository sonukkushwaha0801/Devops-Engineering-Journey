resource "aws_instance" "frontend" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_pair_name
  tags = {
    Name        = var.instance_name
    ManagedBy   = "terraform"
    Environment = "practice"
  }
}
