# Task: Local Provider Basics

# Objective

Create a local file on the system using Terraform Local Provider.

The task demonstrates:
- provider initialization
- local provider usage
- resource creation
- terraform workflow
- output values

---

# Infrastructure Goal

Terraform should:
1. Install and initialize Local Provider
2. Create a local text file
3. Write custom content inside the file
4. Display file path using Terraform output

---

# Resource Used

| Resource     | Purpose           |
| ------------ | ----------------- |
| `local_file` | Create local file |

---

# Concepts Covered

- Terraform Provider
- Terraform Resource
- terraform init
- terraform plan
- terraform apply
- terraform destroy
- outputs
- local infrastructure provisioning

---

# Expected Result

After successful execution:
- a text file should exist locally
- Terraform state should be created
- output should display generated filename

Example:
```text
terraform-demo.txt
```
