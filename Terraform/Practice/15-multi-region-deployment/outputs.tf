output "primary_region_outputs" {
  description = "Primary region deployment details"
  value = {
    region       = var.primary_region
    app_endpoint = try(aws_route53_record.primary_endpoint.fqdn, "")
    rds_endpoint = try(module.primary_region.rds_endpoint, "")
  }
}

output "secondary_region_outputs" {
  description = "Secondary region deployment details"
  value = {
    region           = var.secondary_region
    app_endpoint     = try(aws_route53_record.secondary_endpoint.fqdn, "")
    rds_read_replica = try(module.secondary_region.rds_endpoint, "")
  }
}

output "route53_failover_domain" {
  description = "Route 53 failover domain"
  value       = try(aws_route53_zone.main.name, "")
}

output "cost_analysis" {
  description = "Estimated monthly costs"
  value = {
    primary_region = {
      region        = var.primary_region
      ec2_instances = var.primary_instance_count
      rds_instance  = var.rds_instance_class
    }
    secondary_region = {
      region           = var.secondary_region
      ec2_instances    = var.secondary_instance_count
      rds_read_replica = var.rds_instance_class
    }
    note = "Add actual cost calculation based on your AWS pricing"
  }
}
