provider "local" {

}

resource "local_file" "terraform_demo" {
  filename        = "terraform-demo.txt"
  file_permission = "0744"

  content = <<EOT
========================================
Terraform Local Provider Practical
========================================

Managed By      : Terraform
Repository      : Devops-Engineering-Journey
Environment     : Local Development
Provisioner     : Local Provider
Created By      : Zenithra
Purpose         : Terraform Practice & State Management

----------------------------------------
Terraform Concepts Covered
----------------------------------------
1. Provider Configuration
2. Resource Block Creation
3. Local File Management
4. File Permissions
5. Terraform State Tracking
6. Infrastructure as Code (IaC)

----------------------------------------
Execution Commands
----------------------------------------
terraform init
terraform validate
terraform plan
terraform apply

----------------------------------------
Expected Output
----------------------------------------
- terraform-demo.txt file created
- Permission set to 0744
- Resource tracked in terraform.tfstate

----------------------------------------
Notes
----------------------------------------
This file is fully managed by Terraform.
Manual changes may be overwritten during
future terraform apply operations.

========================================
EOT
}
