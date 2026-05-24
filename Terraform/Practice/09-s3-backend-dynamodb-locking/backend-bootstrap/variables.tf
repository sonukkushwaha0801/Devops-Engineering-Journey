variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Terraform state bucket name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Terraform lock table name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "practice"
}

variable "key_pair_name" {
  description = "AWS EC2 Key Pair Name"
  type        = string
  default     = null
}
