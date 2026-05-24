# Task: Custom tfvars Usage

# Objective

Provision AWS EC2 instances using:
- custom tfvars files
- environment-specific configurations
- reusable Terraform code

The task demonstrates how production teams manage:
- dev
- staging
- prod

configurations separately.

---

# Infrastructure Goal

Terraform should:
1. Use custom tfvars files
2. Deploy environment-specific EC2 instances
3. Dynamically change infrastructure configuration
4. Reuse same Terraform code across environments

---

# Concepts Covered

- Custom tfvars files
- Environment separation
- Variable injection
- terraform apply -var-file
- Reusable infrastructure
- Production configuration management

---

# AWS Services Used

| Service | Purpose         |
| ------- | --------------- |
| EC2     | Virtual Machine |

---

# Expected Result

After successful execution:
- different environments should use different configurations
- same Terraform code should provision different infrastructure
- infrastructure should remain reusable and scalable
