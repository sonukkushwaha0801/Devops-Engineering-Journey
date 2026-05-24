variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
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
}
