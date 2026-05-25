output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.frontend.id
}

output "instance_name" {
  description = "EC2 Instance Name"
  value       = aws_instance.frontend.tags.Name
}

output "common_tags" {
  description = "Centralized Terraform Tags"
  value       = local.common_tags
}
