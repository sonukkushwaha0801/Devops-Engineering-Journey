output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "compute_instance_ids" {
  description = "EC2 instance IDs"
  value       = module.compute.instance_ids
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.db_endpoint
  sensitive   = true
}

output "cloudwatch_dashboard_url" {
  description = "CloudWatch dashboard URL"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${module.monitoring.dashboard_name}"
}

output "workspace" {
  description = "Terraform workspace"
  value       = terraform.workspace
}

output "environment" {
  description = "Environment"
  value       = var.environment
}
