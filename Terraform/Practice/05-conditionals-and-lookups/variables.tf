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

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "instance_types" {
  description = "Environment-specific instance types"
  type        = map(string)
  default = {
    dev     = "t2.micro"
    staging = "t2.small"
    prod    = "t2.xlarge"
  }
}
