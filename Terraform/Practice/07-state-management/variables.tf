variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
  default     = "ami-0c94855ba95c71c99"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 Instance Name"
  type        = string
  default     = "MyEC2Instance"
}

variable "key_pair_name" {
  description = "Key pair named, if using while creating EC2 instance"
  type        = string
  default     = null
}
