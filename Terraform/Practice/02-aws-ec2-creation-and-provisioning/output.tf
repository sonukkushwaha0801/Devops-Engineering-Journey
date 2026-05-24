output "instance_id" {
  description = "EC2 Instance ID"

  value = aws_instance.frontend.id
}

output "public_ip" {
  description = "EC2 Public IP"

  value = aws_instance.frontend.public_ip
}
