# Task: Terraform S3 Backend with DynamoDB Locking

# Objective

Configure production-grade Terraform remote backend using:
- S3 backend
- DynamoDB state locking

The task demonstrates how enterprise Terraform teams manage:
- centralized Terraform state
- state locking
- collaborative infrastructure workflows
- secure backend architecture

---

# Infrastructure Goal

Terraform should:
1. Create S3 bucket for remote Terraform state
2. Enable bucket versioning
3. Enable bucket encryption
4. Block public access
5. Create DynamoDB table for state locking
6. Configure Terraform remote backend
7. Store Terraform state remotely

---

# Concepts Covered

- Remote Backend
- S3 Backend
- DynamoDB Locking
- Backend Bootstrap
- Remote State Management
- State Locking
- State Migration
- Production Terraform Architecture

---

# AWS Services Used

| Service  | Purpose                |
| -------- | ---------------------- |
| S3       | Remote Terraform State |
| DynamoDB | State Locking          |
| EC2      | Sample Infrastructure  |

---

# Expected Result

After successful execution:
- Terraform state should move from local → S3
- DynamoDB locking should work
- infrastructure should use remote backend
- collaborative Terraform workflow should become possible
