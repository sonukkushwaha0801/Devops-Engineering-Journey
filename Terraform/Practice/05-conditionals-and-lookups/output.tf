output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.frontend.id
}

output "public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.frontend.public_ip
}

output "instance_type" {
  description = "Selected EC2 instance type"
  value       = aws_instance.frontend.instance_type
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "key_pair" {
  description = "Key pair used for the instance?"
  value       = var.key_pair != null ? "Yes, key used Name: " + var.key_pair : "No key pair specified"
}
