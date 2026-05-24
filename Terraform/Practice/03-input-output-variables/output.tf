output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.frontend.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.frontend.public_ip
}

output "instance_name" {
  description = "EC2 instance name"
  value       = aws_instance.frontend.tags.Name
}
output "key_used" {
  description = "Used Key pair while EC2 Creation?"
  value       = var.key_name != null ? var.key_name : "No key pair used"
}
