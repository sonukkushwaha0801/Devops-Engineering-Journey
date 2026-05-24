variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
  default     = "ami-07a00cf47ddbc844c"
}

variable "key_pair" {
  description = "Using Key pair to secure connection"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
  default     = "default-server"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "default"
}
