# Terraform Basics

# What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool by HashiCorp used to provision, manage, and version infrastructure using declarative configuration files.

Terraform supports:
- Cloud Infrastructure
- SaaS Platforms
- DNS
- Kubernetes
- Networking
- Monitoring tools

Examples:
- AWS
- Azure
- GCP
- Cloudflare
- GitHub
- Kubernetes

---

# Core Terraform Philosophy

Terraform follows:

- Declarative Infrastructure
- Desired State Management
- Immutable Infrastructure mindset
- Infrastructure Versioning
- Automation-first provisioning

You define:
```hcl
what infrastructure should exist
```

Terraform determines:
```hcl
how to create/update/delete it
```

---

# Infrastructure as Code (IaC)

Infrastructure is managed using code instead of manual console operations.

Benefits:
- Version Control
- Reproducibility
- Automation
- Auditability
- Scalability
- Collaboration
- Disaster Recovery

Production Impact:
- Eliminates configuration drift
- Enables CI/CD-driven infrastructure delivery
- Standardizes infrastructure provisioning

---

# Terraform Architecture

Basic Flow:

```text
Terraform Configurations
        ↓
Terraform Core
        ↓
Provider Plugins
        ↓
Target APIs (AWS/GCP/Azure/etc.)
```

---

# Terraform Workflow

## 1. Write Configuration

Define infrastructure in `.tf` files.

Example:
```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

---

## 2. Initialize Terraform

```bash
terraform init
```

Purpose:
- Downloads providers
- Initializes backend
- Creates `.terraform/`
- Generates `.terraform.lock.hcl`

Production Note:
Always run after:
- cloning repo
- provider changes
- backend changes
- module changes

---

## 3. Validate Configuration

```bash
terraform validate
```

Checks:
- syntax
- internal configuration validity

Does NOT:
- check cloud-side permissions
- verify infrastructure existence

---

## 4. Format Configuration

```bash
terraform fmt
```

Production Practice:
Used in:
- pre-commit hooks
- CI validation pipelines

---

## 5. Generate Execution Plan

```bash
terraform plan
```

Purpose:
- Shows infrastructure changes before execution

Operations:
- Create
- Update
- Destroy

Production Importance:
Critical for:
- change review
- approval workflows
- safe deployments

Enterprise Practice:
Never directly run `terraform apply` in production without reviewing a plan.

---

## 6. Apply Infrastructure

```bash
terraform apply
```

Purpose:
Creates/updates infrastructure.

Production Practice:
```bash
terraform apply tfplan
```

Reason:
Prevents drift between plan and apply stages.

---

## 7. Destroy Infrastructure

```bash
terraform destroy
```

Purpose:
Removes managed infrastructure.

Production Warning:
- Dangerous in shared environments
- Usually restricted in production accounts

Enterprise Practice:
Use IAM restrictions + approval workflows.

---

# Terraform State

Terraform stores infrastructure mapping in:
```text
terraform.tfstate
```

Contains:
- Resource mappings
- Metadata
- Dependency information
- Current infrastructure state

Critical Concept:
Terraform state is the source of truth.

Production Risks:
- State corruption
- Concurrent modifications
- Sensitive data exposure

Production Solution:
- Remote backend
- State locking
- Versioning
- Encryption

---

# Declarative vs Imperative

## Declarative (Terraform)

You define desired state.

Example:
```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "prod-app-logs"
}
```

Terraform decides execution steps.

---

## Imperative

You define step-by-step commands.

Example:
```bash
create bucket
configure permissions
enable versioning
```

---

# Idempotency

Terraform is idempotent.

Meaning:
Repeated applies produce the same infrastructure state without unnecessary changes.

Production Importance:
- Safe automation
- Predictable deployments
- Stable CI/CD pipelines

---

# Resource Dependency Management

Terraform automatically builds dependency graphs.

Example:
```hcl
EC2 depends on:
- VPC
- Subnet
- Security Group
```

Terraform creates resources in correct order automatically.

Manual dependency:
```hcl
depends_on = [aws_security_group.web_sg]
```

Production Note:
Avoid excessive explicit dependencies.

Reason:
Can slow execution and complicate graph resolution.

---

# Terraform File Types

| File Type   | Purpose                      |
| ----------- | ---------------------------- |
| `.tf`       | Main Terraform configuration |
| `.tfvars`   | Variable values              |
| `.tfstate`  | Infrastructure state         |
| `.tfplan`   | Saved execution plan         |
| `.lock.hcl` | Provider version locking     |

---

# Important Terraform Commands

| Command              | Purpose                        |
| -------------------- | ------------------------------ |
| `terraform init`     | Initialize working directory   |
| `terraform validate` | Validate configuration         |
| `terraform fmt`      | Format configuration           |
| `terraform plan`     | Preview infrastructure changes |
| `terraform apply`    | Apply infrastructure           |
| `terraform destroy`  | Remove infrastructure          |
| `terraform show`     | Show state/plan details        |
| `terraform output`   | Display outputs                |

---

# Production Best Practices

## Use Remote Backend
Never use local state in team environments.

Preferred:
- S3 + DynamoDB locking
- Terraform Cloud
- Consul

---

## Pin Provider Versions

Example:
```hcl
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}
```

Reason:
Avoid unexpected provider breaking changes.

---

## Separate Environments

Recommended:
```text
dev
staging
prod
```

Avoid:
```text
single shared state for everything
```

---

## Never Hardcode Secrets

Avoid:
- AWS keys
- passwords
- tokens

Use:
- Vault
- AWS Secrets Manager
- environment variables
- CI/CD secret stores

---

## Use Modular Architecture

Avoid giant monolithic Terraform files.

Use:
- reusable modules
- environment separation
- shared infrastructure modules

---

# Common Enterprise Mistakes

| Mistake                      | Impact              |
| ---------------------------- | ------------------- |
| Local state in team          | State conflicts     |
| No locking                   | State corruption    |
| No version pinning           | Unexpected failures |
| Hardcoded values             | Security risks      |
| Manual console changes       | Drift               |
| Giant monolithic configs     | Poor scalability    |
| Applying without plan review | Production outages  |

---

# Interview Questions

## Why Terraform over CloudFormation?

Terraform:
- Multi-cloud support
- Better modularity
- Larger ecosystem
- Provider flexibility

CloudFormation:
- AWS-native
- tighter AWS integration

---

## Why is Terraform state important?

Terraform uses state to:
- map resources
- track infrastructure
- detect drift
- determine changes

Without state:
Terraform cannot manage existing infrastructure reliably.

---

## Why use remote backend?

Benefits:
- Collaboration
- State locking
- Versioning
- Centralized management
- Recovery capability

---

## Difference between `terraform plan` and `terraform apply`

| Command | Purpose         |
| ------- | --------------- |
| `plan`  | Preview changes |
| `apply` | Execute changes |

---

## What problem does idempotency solve?

Ensures:
- repeated execution is safe
- infrastructure remains predictable
- automation pipelines stay stable

---

# Production Reality

Terraform is not just provisioning.

In real enterprise environments Terraform is used for:
- platform engineering
- infrastructure governance
- environment standardization
- drift detection
- multi-account AWS management
- CI/CD automation
- disaster recovery
- infrastructure auditing

Terraform becomes a critical operational system, not just a provisioning tool.
