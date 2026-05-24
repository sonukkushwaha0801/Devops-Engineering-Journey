# Task: Terraform Workspaces

# Objective

Manage multiple environments using:
- Terraform Workspaces
- environment-aware infrastructure
- isolated Terraform states

The task demonstrates how Terraform manages:
- dev
- staging
- prod

environments using same Terraform codebase.

---

# Infrastructure Goal

Terraform should:
1. Create multiple workspaces
2. Provision isolated infrastructure
3. Maintain separate Terraform state per environment
4. Dynamically configure infrastructure using workspace name

---

# Concepts Covered

- terraform workspace
- workspace state isolation
- terraform.workspace
- environment-aware infrastructure
- reusable Terraform configuration

---

# AWS Services Used

| Service | Purpose         |
| ------- | --------------- |
| EC2     | Virtual Machine |

---

# Expected Result

After successful execution:
- each workspace should maintain separate state
- infrastructure should isolate by environment
- same Terraform code should provision different environments
