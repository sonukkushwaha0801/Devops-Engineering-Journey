variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 Instance Name"
  type        = string
  default     = "Server-Created"
}

variable "key_pair_name" {
  description = "AWS Key Pair Name"
  type        = string
  default     = null
}

variable "private_key_path" {
  description = "PEM private key file path"
  type        = string
  default     = null
}
