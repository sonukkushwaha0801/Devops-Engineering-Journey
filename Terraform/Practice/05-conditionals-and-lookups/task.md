# Task: Terraform Conditionals and lookup()

# Objective

Provision AWS EC2 infrastructure using:
- conditional expressions
- lookup() function
- map variables
- environment-aware configurations

The task demonstrates production-style dynamic infrastructure provisioning.

---

# Infrastructure Goal

Terraform should:
1. Dynamically select instance type
2. Use environment-based configuration
3. Apply conditional tagging
4. Use lookup() with map variables
5. Reuse same Terraform code across environments

---

# Concepts Covered

- Conditional Expressions
- lookup() Function
- Map Variables
- Environment-based Infrastructure
- Dynamic Configuration
- Production Terraform Logic

---

# AWS Services Used

| Service | Purpose         |
| ------- | --------------- |
| EC2     | Virtual Machine |

---

# Expected Result

After successful execution:
- different environments should provision different instance sizes
- conditional values should apply automatically
- lookup() should dynamically fetch configuration values
