variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
  default     = "ami-05cab0e4355c1d62f"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 Instance Name"
  type        = string
  default     = "Instance Created"
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "practice"
}

variable "key_pair_name" {
  description = "AWS Key Pair Name"
  type        = string
  default = null
}
