# Task: Terraform for_each and count

# Objective

Provision multiple AWS resources dynamically using:
- count
- for_each

The task demonstrates scalable Terraform infrastructure provisioning patterns.

---

# Infrastructure Goal

Terraform should:
1. Create multiple EC2 instances using count
2. Create multiple Security Groups using for_each
3. Apply environment-specific tagging
4. Demonstrate dynamic infrastructure provisioning

---

# Concepts Covered

- count
- for_each
- indexed resources
- key-based resources
- dynamic infrastructure
- scalable Terraform design

---

# AWS Services Used

| Service         | Purpose                |
| --------------- | ---------------------- |
| EC2             | Virtual Machines       |
| Security Groups | Network Access Control |

---

# Expected Result

After successful execution:
- multiple EC2 instances should launch
- multiple security groups should create dynamically
- infrastructure should scale using Terraform iteration logic
