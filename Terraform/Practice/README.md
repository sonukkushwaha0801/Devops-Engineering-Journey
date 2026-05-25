# Terraform Practice Repository

Production-oriented Terraform practice repository focused on real-world infrastructure engineering, state management, reusable modules, backend architecture, provisioning workflows, and scalable DevOps patterns.

---

# Practice Roadmap

| No. | Folder | Description |
|---|---|---|
| 01 | `01-local-provider-basics` | Terraform lifecycle using local provider and local resources |
| 02 | `02-aws-ec2-bootstrap-and-provisioning` | EC2 provisioning with bootstrap scripts and infrastructure initialization |
| 03 | `03-input-output-variables` | Input variables, outputs, variable types, and parameterized infrastructure |
| 04 | `04-custom-tfvars` | Environment-specific configurations using custom tfvars files |
| 05 | `05-conditionals-and-lookups` | Conditional expressions, maps, lookup(), and dynamic infrastructure logic |
| 06 | `06-modules` | Reusable Terraform modules and modular infrastructure architecture |
| 07 | `07-state-management` | Terraform state operations, drift understanding, and state inspection |
| 08 | `08-workspaces` | Workspace-based environment isolation and multi-environment deployments |
| 09 | `09-s3-backend-dynamodb-locking` | Remote backend setup with S3 state storage and DynamoDB locking |
| 10 | `10-provisioners` | local-exec, remote-exec, file provisioners, and bootstrap automation |
| 11 | `11-for-each-and-count` | Dynamic infrastructure creation using count and for_each |
| 12 | `12-locals-and-tagging` | locals, reusable tagging strategy, and centralized configuration |
| 13 | `13-dynamic-blocks` | Dynamic nested block generation and scalable resource configuration |
| 14 | `14-vault-integration` | HashiCorp Vault integration and secret management workflows |
| 15 | `15-multi-region-deployment` | Multi-region AWS infrastructure deployment using provider aliases |
| 16 | `16-production-patterns` | Production-grade Terraform architecture and environment structure |

---

# Repository Goals

This repository focuses on:

- Production-oriented Terraform practices
- Real-world infrastructure workflows
- Reusable module architecture
- State management and backend operations
- Multi-environment infrastructure design
- Infrastructure automation patterns
- Scalable Terraform engineering
- DevOps operational workflows

---

# Skills Covered

## Terraform Core
- Providers
- Resources
- Variables
- Outputs
- Modules
- Locals
- Dynamic Blocks

---

## State & Backend Management
- Terraform State
- Remote Backend
- S3 Backend
- DynamoDB Locking
- Workspace Isolation
- Drift Understanding

---

## Infrastructure Patterns
- EC2 Provisioning
- Bootstrap Automation
- Tagging Standards
- Multi-Region Deployment
- Environment Separation
- Reusable Infrastructure

---

## Production Practices
- Infrastructure Modularity
- Backend Isolation
- Variable Management
- Secret Management
- State Security
- Terraform Workflow Standardization

---

# Recommended Execution Order

Execute folders sequentially:

```text
01 → 02 → 03 → ...
```

Reason:
Each practice builds on concepts from previous exercises.

---

# Standard Terraform Workflow

Most exercises follow:

```bash
terraform init

terraform validate

terraform plan

terraform apply

terraform destroy
```

---

# Production Notes

This repository is intentionally structured similar to real DevOps/Terraform engineering repositories.

Focus areas:
- scalability
- maintainability
- infrastructure organization
- operational workflows
- production infrastructure thinking

---

# Future Expansion

Planned advanced projects:

- Infrastructure Migration to Terraform
- Drift Detection Automation
- Terraform Governance
- Multi-Environment Platform Engineering
- Terraform CI/CD Pipelines
- Infrastructure Observability Stack
```"""
