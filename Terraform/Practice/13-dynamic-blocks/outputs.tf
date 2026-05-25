output "security_group_id" {
  description = "Dynamic Security Group ID"

  value = aws_security_group.dynamic_sg.id
}

output "allowed_ports" {
  description = "Configured ingress ports"

  value = var.allowed_ports
}

output "instance_id" {
  description = "EC2 Instance ID"

  value = aws_instance.frontend.id
}
