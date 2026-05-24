# Terraform Production Best Practices

# Production Terraform Mindset

Terraform in production is NOT just:
```text
resource creation
```

It becomes:
- infrastructure platform
- operational control layer
- governance system
- automation engine

Production Terraform engineering focuses on:
- scalability
- reliability
- security
- maintainability
- collaboration

---

# Infrastructure Design Principles

# Keep Infrastructure Modular

Avoid:
```text
One giant Terraform project
```

Use:
```text
Reusable modules
```

Example:
```text
modules/
├── vpc/
├── ec2/
├── alb/
├── rds/
└── monitoring/
```

---

# Separate Environments

Recommended:
```text
dev
staging
prod
```

Avoid:
```text
Single shared environment
```

Production Benefit:
- isolation
- safer deployments
- controlled promotion

---

# Separate Terraform States

Separate state for:
- networking
- compute
- IAM
- monitoring
- Kubernetes

Avoid:
```text
Single massive state file
```

Reason:
- reduced blast radius
- faster plans
- safer recovery

---

# State Management Best Practices

# Always Use Remote Backend

Recommended:
```text
S3 + DynamoDB
```

OR:
```text
Terraform Cloud
```

---

# Enable State Locking

Mandatory for:
- teams
- CI/CD
- collaborative environments

Purpose:
Prevent:
- concurrent apply
- state corruption

---

# Enable State Versioning

Benefits:
- rollback
- recovery
- auditing

---

# Encrypt State

Protect:
- secrets
- infrastructure metadata
- outputs

---

# Never Manually Edit State

Avoid:
```text
editing terraform.tfstate manually
```

Use:
```bash
terraform state
```

commands instead.

---

# Variable Management Best Practices

# Avoid Hardcoded Values

Bad:
```hcl
instance_type = "t2.micro"
```

Good:
```hcl
instance_type = var.instance_type
```

---

# Use Variable Validation

Example:
```hcl
validation {
  condition = contains(
    ["dev", "staging", "prod"],
    var.environment
  )
}
```

Purpose:
Prevent invalid deployments.

---

# Separate tfvars Per Environment

Recommended:
```text
dev.tfvars
staging.tfvars
prod.tfvars
```

---

# Use locals for Shared Logic

Example:
```hcl
locals {
  common_tags = {
    ManagedBy = "terraform"
  }
}
```

---

# Security Best Practices

# Never Hardcode Secrets

Avoid:
- passwords
- API keys
- tokens
- access keys

inside:
- `.tf`
- `.tfvars`

files.

---

# Use Secret Management Systems

Recommended:
- Vault
- AWS Secrets Manager
- Azure Key Vault
- GCP Secret Manager

---

# Use Least Privilege IAM

Terraform should only have:
```text
minimum required permissions
```

Avoid:
```text
AdministratorAccess
```

---

# Use Dedicated Terraform IAM Roles

Recommended:
```text
terraform-dev-role
terraform-prod-role
```

Benefits:
- auditing
- isolation
- security

---

# Enable Encryption Everywhere

Examples:
- S3 encryption
- EBS encryption
- RDS encryption

---

# Restrict Public Access

Never expose:
- state buckets
- databases
- internal infrastructure

publicly.

---

# Provider Best Practices

# Pin Provider Versions

Example:
```hcl
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}
```

Purpose:
Prevent unexpected provider changes.

---

# Commit .terraform.lock.hcl

Benefits:
- deterministic builds
- CI/CD consistency
- reproducible environments

---

# CI/CD Best Practices

# Use Validation Pipelines

Recommended CI steps:
```text
terraform fmt
terraform validate
terraform plan
```

---

# Separate Plan and Apply

Production Pattern:
```text
PR → terraform plan
Approval → terraform apply
```

---

# Never Auto-Apply to Production

Require:
- approval workflow
- review process

---

# Store Plan Files

Example:
```bash
terraform plan -out=tfplan
```

Apply:
```bash
terraform apply tfplan
```

Purpose:
Ensures reviewed plan is applied exactly.

---

# Use OIDC Authentication

Preferred over:
```text
static access keys
```

Especially in:
- GitHub Actions
- GitLab CI
- Jenkins

---

# Module Best Practices

# Keep Modules Small

One module:
```text
One responsibility
```

---

# Avoid Giant Modules

Bad:
```text
One module creates everything
```

Problems:
- poor scalability
- difficult debugging
- tight coupling

---

# Version Modules

Always pin:
```hcl
version = "x.x.x"
```

for external modules.

---

# Standardize Outputs

Expose:
- IDs
- ARNs
- endpoints
- IPs

---

# Use README per Module

Document:
- inputs
- outputs
- usage examples

---

# Infrastructure Organization Best Practices

# Recommended Repository Structure

```text
Terraform/
│
├── modules/
├── environments/
├── backend-bootstrap/
├── projects/
└── shared/
```

---

# Separate Shared Infrastructure

Examples:
- VPC
- IAM
- DNS
- monitoring

from:
- application infrastructure

---

# Use Naming Standards

Example:
```text
prod-frontend-web
dev-backend-api
```

Benefits:
- readability
- governance
- automation

---

# Tagging Best Practices

Mandatory Tags:
```text
Environment
Application
Owner
ManagedBy
CostCenter
```

Production Benefits:
- cost tracking
- governance
- automation
- auditing

---

# Drift Management Best Practices

# Restrict Manual Console Changes

Manual changes cause:
```text
Infrastructure Drift
```

---

# Run Drift Detection

Common Commands:
```bash
terraform plan
terraform refresh
```

Production Pattern:
Scheduled drift detection pipelines.

---

# Use Infrastructure Governance

Examples:
- Sentinel
- OPA
- AWS Config
- SCPs

---

# Terraform Performance Best Practices

# Split Large States

Benefits:
- faster plans
- smaller blast radius
- scalable operations

---

# Avoid Massive Monolithic Projects

Problems:
- slow execution
- lock contention
- difficult recovery

---

# Use for_each Over count

Better:
- state stability
- predictable indexing

---

# Use Data Sources Carefully

Excessive data sources:
- slow plans
- increase API calls

---

# Disaster Recovery Best Practices

# Backup State

Mandatory:
- versioning
- backup strategy
- recovery testing

---

# Use Multi-Region DR

Critical systems should support:
- failover
- backup regions
- replication

---

# Test Recovery Regularly

Production Requirement:
Recovery drills.

---

# Logging and Monitoring

# Enable Cloud Audit Logging

Examples:
- CloudTrail
- Azure Activity Logs
- GCP Audit Logs

---

# Monitor Terraform Pipelines

Track:
- failed applies
- drift
- unauthorized changes

---

# Audit Terraform Operations

Important For:
- compliance
- incident response
- governance

---

# Common Enterprise Mistakes

| Mistake                | Impact                    |
| ---------------------- | ------------------------- |
| Local state in teams   | Corruption                |
| Hardcoded secrets      | Security risk             |
| Giant state files      | Scalability problems      |
| No module structure    | Poor maintainability      |
| Manual console changes | Drift                     |
| No locking             | Broken state              |
| Auto-apply production  | Outage risk               |
| Shared admin IAM       | Compliance/security issue |

---

# Recommended Production Terraform Workflow

```text
Developer
    ↓
Git Push
    ↓
CI Validation
    ↓
terraform fmt
    ↓
terraform validate
    ↓
terraform plan
    ↓
Approval
    ↓
terraform apply
```

---

# Enterprise Terraform Architecture Pattern

```text
Terraform
    ↓
Reusable Modules
    ↓
Environment Isolation
    ↓
Remote Backend
    ↓
CI/CD Automation
    ↓
Governance & Security
```

---

# Recommended Terraform Tooling

| Tool       | Purpose                   |
| ---------- | ------------------------- |
| tflint     | Terraform linting         |
| tfsec      | Security scanning         |
| checkov    | Policy scanning           |
| Terragrunt | Large-scale orchestration |
| pre-commit | Local validation          |
| Infracost  | Cost estimation           |

---

# Production Validation Pipeline

Recommended:
```bash
terraform fmt -check

terraform validate

terraform plan
```

Optional Security:
```bash
tfsec

checkov
```

---

# Git Ignore Best Practices

Recommended `.gitignore`:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
terraform.tfvars
*.tfvars
```

---

# Interview Questions

## Why should Terraform state be remote?

Benefits:
- collaboration
- locking
- backup
- recovery
- security

---

## Why separate Terraform states?

Benefits:
- scalability
- reduced blast radius
- easier recovery
- faster operations

---

## Why avoid hardcoded secrets?

Risks:
- credential leakage
- Git exposure
- compliance violations

---

## Why split plan and apply in CI/CD?

Ensures:
- reviewed infrastructure changes
- safer production deployments

---

## Why use modules?

Benefits:
- reusability
- standardization
- scalability
- maintainability

---

## Why is drift dangerous?

Because:
```text
Terraform state ≠ actual infrastructure
```

Can cause:
- unexpected changes
- infrastructure replacement
- outages

---

# Production Reality

Production Terraform engineering is primarily about:
- operational safety
- infrastructure governance
- scalability
- collaboration
- reliability

The real difficulty in Terraform is NOT writing resources.

The real complexity comes from:
- state architecture
- environment isolation
- CI/CD automation
- governance
- drift management
- large-scale infrastructure operations

Mature DevOps teams treat Terraform as:
```text
Critical Infrastructure Platform
```

not just:
```text
Infrastructure Provisioning Tool
```
