output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.frontend.id
}

output "public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.frontend.public_ip
}

output "key_pair" {
  description = "Key pair used for the instance?"
  value       = var.key_pair_name != null ? "Yes, key used Name: ${var.key_pair_name}" : "No key pair specified"
}
