resource "aws_instance" "frontend" {
  ami = var.ami_id

  instance_type = lookup(var.instance_types, var.environment, "t3.micro")

  tags = {
    Name        = "${var.environment}-frontend"
    Environment = var.environment
    Backup      = var.environment == "prod" ? "enabled" : "disabled"
    ManagedBy   = "terraform"
  }
}
