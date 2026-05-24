variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "key_name" {
  description = "Key pair name"
  type        = string
  default     = null
}
variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
  default     = "ami-0dba2cb6798deb6d8"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
  default     = "terraform-ec2"
}
