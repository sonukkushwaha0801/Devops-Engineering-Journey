output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.frontend.id
}

output "public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.frontend.public_ip
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.frontend_sg.id
}

output "remote_backend_bucket" {
  description = "Terraform Remote Backend Bucket"
  value       = "zenithra-terraform-state-demo"
}
