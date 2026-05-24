output "s3_bucket_name" {
  description = "Terraform remote state S3 bucket"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  description = "Terraform state locking DynamoDB table"
  value       = aws_dynamodb_table.terraform_lock.name
}

