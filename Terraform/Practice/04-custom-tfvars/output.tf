output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.frontend.id
}

output "public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.frontend.public_ip
}

output "Key Used" {
  description = "Using key-pair while creating EC2 Instance?"
  value       = var.key_pair != null ? "Yes, Named as " + var.key_pair : "No"
}

output "environment" {
  description = "Deployment Environment"
  value       = var.environment
}
