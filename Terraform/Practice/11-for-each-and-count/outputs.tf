output "instance_ids" {
  description = "EC2 Instance IDs"
  value       = aws_instance.frontend[*].id
}

output "security_group_ids" {
  description = "Security Group IDs"
  value = {
    for key, sg in aws_security_group.dynamic_sg :
    key => sg.id
  }
}
