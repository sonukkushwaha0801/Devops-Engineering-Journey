output "workspace_name" {
  description = "Current Terraform workspace"

  value = terraform.workspace
}

output "instance_id" {
  description = "EC2 Instance ID"

  value = aws_instance.frontend.id
}

output "public_ip" {
  description = "EC2 Public IP"

  value = aws_instance.frontend.public_ip
}

output "instance_type" {
  description = "Workspace-selected instance type"

  value = aws_instance.frontend.instance_type
}

output "Key Used" {
  description = "Key used in creation of EC2 Instance"
  value = var.key_pair != null ? "Yes, key named as:" + var.key_pair : "No"
}
