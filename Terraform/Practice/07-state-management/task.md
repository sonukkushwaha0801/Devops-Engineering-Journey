# Task: Terraform State Management

# Objective

Manage Terraform state using:
- local state
- terraform state commands
- state inspection
- state removal
- state movement

The task demonstrates how Terraform tracks infrastructure internally.

---

# Infrastructure Goal

Terraform should:
1. Provision AWS EC2 instance
2. Generate Terraform state
3. Inspect Terraform state
4. Manipulate Terraform state safely
5. Understand state lifecycle operations

---

# Concepts Covered

- terraform.tfstate
- terraform state list
- terraform state show
- terraform state rm
- terraform state mv
- state inspection
- infrastructure tracking

---

# AWS Services Used

| Service | Purpose         |
| ------- | --------------- |
| EC2     | Virtual Machine |

---

# Expected Result

After successful execution:
- Terraform should maintain infrastructure state
- state commands should expose infrastructure metadata
- state operations should demonstrate Terraform resource tracking
