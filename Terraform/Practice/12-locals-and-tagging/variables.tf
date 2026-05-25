variable "aws_region" {
  description = "AWS Region"
  type = string
  default = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t2.micro"
}

variable "environment" {
  description = "Deployment Environment"
  type = string
}

variable "project_name" {
  description = "Project Name"
  type = string
}

variable "owner" {
  description = "Infrastructure Owner"
  type = string
}
