variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "key_pair" {
  description = "Using Key pair to secure connection"
  type        = string
  default     = null
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "EC2 Instance Name"
  type        = string
  default     = "server created"
}
