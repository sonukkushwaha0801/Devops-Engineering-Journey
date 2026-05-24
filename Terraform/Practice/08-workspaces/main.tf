resource "aws_instance" "frontend" {
  ami = var.ami_id
  # lookup(map, key, default)
  instance_type = lookup(var.instance_types, terraform.workspace, "t3.micro")
  key_name      = var.key_pair

  tags = {
    Name        = "${terraform.workspace}-frontend"
    Environment = terraform.workspace
    ManagedBy   = "terraform"
  }
}
