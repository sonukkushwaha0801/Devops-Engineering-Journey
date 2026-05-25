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

variable "instance_count" {
  description = "Number of EC2 Instances"
  type        = number
  default     = 3
}

variable "security_groups" {
  description = "Security Group Names"
  type        = list(string)
  default = [
    "frontend-sg",
    "backend-sg",
    "monitoring-sg"
  ]
}
