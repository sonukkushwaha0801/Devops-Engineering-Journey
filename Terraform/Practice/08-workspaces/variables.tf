variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "key_pair" {
  description = "Provide key name which you are going to use while creating EC2"
  type        = string
  default     = null
}
variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "instance_types" {
  description = "Workspace-based EC2 instance types"
  type        = map(string)
  default = {
    default = "t2.micro"
    dev     = "t2.micro"
    prod    = "t3.medium"
  }
}
