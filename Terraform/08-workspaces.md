# Terraform Workspaces

# What are Terraform Workspaces?

Terraform Workspaces allow managing multiple state files from the same Terraform configuration.

Each workspace maintains:
- separate state
- isolated infrastructure tracking

Common Usage:
```text
dev
staging
prod
```

---

# Why Workspaces are Important

Without workspaces:
- separate directories required
- duplicated configurations
- difficult environment management

Workspaces provide:
- environment isolation
- reusable infrastructure
- cleaner management

---

# Workspace Architecture

```text
Same Terraform Code
        ↓
Different Workspaces
        ↓
Different State Files
```

Example:
```text
default
dev
staging
prod
```

Each workspace:
```text
Maintains its own state
```

---

# Default Workspace

Terraform automatically creates:
```text
default
```

Check current workspace:
```bash
terraform workspace show
```

---

# List Workspaces

Command:
```bash
terraform workspace list
```

Example Output:
```text
* default
  dev
  staging
  prod
```

`*` indicates active workspace.

---

# Create Workspace

Command:
```bash
terraform workspace new dev
```

Example:
```bash
terraform workspace new prod
```

Terraform:
- creates new workspace
- creates isolated state

---

# Switch Workspace

Command:
```bash
terraform workspace select dev
```

Example:
```bash
terraform workspace select prod
```

---

# Delete Workspace

Command:
```bash
terraform workspace delete dev
```

Restriction:
Cannot delete active workspace.

---

# Workspace State Isolation

Each workspace stores:
```text
separate terraform.tfstate
```

Example:
```text
default → default infrastructure
dev     → dev infrastructure
prod    → prod infrastructure
```

---

# Workspace-Based Infrastructure

Example:
```hcl
resource "aws_instance" "frontend" {
  ami = "ami-0f5ee92e2d63afc18"

  instance_type = terraform.workspace == "prod"
    ? "t3.large"
    : "t2.micro"
}
```

Behavior:
- prod → larger instance
- others → smaller instance

---

# terraform.workspace

Built-in Terraform variable:
```hcl
terraform.workspace
```

Returns:
```text
Current active workspace name
```

Production Usage:
- environment logic
- dynamic naming
- scaling configuration

---

# Workspace Naming Example

```hcl
tags = {
  Environment = terraform.workspace
}
```

---

# Workspace-Based Naming

Example:
```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "${terraform.workspace}-app-logs"
}
```

Result:
```text
dev-app-logs
prod-app-logs
```

Production Benefit:
Avoids naming conflicts.

---

# Using lookup() with Workspaces

## Variable

```hcl
variable "instance_types" {
  type = map(string)

  default = {
    dev     = "t2.micro"
    staging = "t2.small"
    prod    = "t3.large"
  }
}
```

---

## Resource

```hcl
resource "aws_instance" "frontend" {
  ami = "ami-0f5ee92e2d63afc18"

  instance_type = lookup(
    var.instance_types,
    terraform.workspace,
    "t2.micro"
  )
}
```

Production Advantage:
- centralized configuration
- scalable environment management

---

# Workspace + tfvars Pattern

Example:
```text
dev.tfvars
staging.tfvars
prod.tfvars
```

Apply:
```bash
terraform workspace select prod

terraform apply -var-file="prod.tfvars"
```

Production Pattern:
```text
workspace → state isolation
tfvars    → environment configuration
```

---

# Workspace Directory Structure

```text
Terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
│
├── dev.tfvars
├── staging.tfvars
└── prod.tfvars
```

---

# Workspace-Aware Tags

Example:
```hcl
locals {
  common_tags = {
    Environment = terraform.workspace
    ManagedBy   = "terraform"
  }
}
```

Usage:
```hcl
tags = local.common_tags
```

---

# Workspace-Aware Scaling

Example:
```hcl
variable "instance_counts" {
  type = map(number)

  default = {
    dev     = 1
    staging = 2
    prod    = 4
  }
}
```

Usage:
```hcl
count = lookup(
  var.instance_counts,
  terraform.workspace,
  1
)
```

---

# Workspace State Location

Local Backend:
```text
terraform.tfstate.d/
```

Example:
```text
terraform.tfstate.d/dev/
terraform.tfstate.d/prod/
```

---

# Workspace Limitations

Workspaces are NOT ideal for:
- completely different architectures
- different providers
- different backend configs
- strict enterprise isolation

---

# When NOT to Use Workspaces

Avoid workspaces if:
- environments differ heavily
- separate AWS accounts used
- separate backend required
- compliance isolation needed

Better Alternative:
```text
Separate root modules/projects
```

---

# Production Workspace Strategy

Good Use Cases:
- small-medium projects
- same architecture
- isolated state
- environment scaling

Bad Use Cases:
- enterprise multi-account infra
- different network architectures
- strict compliance boundaries

---

# Enterprise Pattern

Common Enterprise Structure:

```text
dev/
staging/
prod/
```

with:
- separate backends
- separate AWS accounts
- separate CI/CD pipelines

Workspaces mostly used for:
- lightweight isolation
- temporary environments
- testing

---

# Workspace Automation Commands

## Create and Switch

```bash
terraform workspace new dev
```

---

## Select Workspace

```bash
terraform workspace select prod
```

---

## Show Current Workspace

```bash
terraform workspace show
```

---

## List Workspaces

```bash
terraform workspace list
```

---

# Common Enterprise Mistakes

| Mistake                                         | Impact               |
| ----------------------------------------------- | -------------------- |
| Using workspaces for everything                 | Poor scalability     |
| No environment naming standard                  | Confusion            |
| Same backend for all environments               | Large blast radius   |
| Hardcoded environment configs                   | Poor maintainability |
| Using workspaces across different architectures | Complexity           |

---

# Production Best Practices

## Use Workspace Naming Standards

Recommended:
```text
dev
staging
prod
```

Avoid:
```text
test1
myworkspace
abc
```

---

## Combine Workspaces with Maps

Use:
```hcl
lookup()
```

instead of:
```hcl
nested conditionals
```

---

## Use tfvars with Workspaces

Pattern:
```bash
terraform workspace select prod

terraform apply -var-file="prod.tfvars"
```

---

## Avoid Workspace Overengineering

If environments differ significantly:
```text
Use separate Terraform projects
```

---

## Use Separate Accounts for Production

Production-grade environments should isolate:
- IAM
- networking
- state
- billing

---

# Interview Questions

## What are Terraform Workspaces?

Workspaces allow multiple state files using the same Terraform configuration.

---

## Why use Workspaces?

Benefits:
- state isolation
- environment separation
- reusable infrastructure

---

## What does terraform.workspace do?

Returns current active workspace name.

---

## Are Workspaces Enough for Enterprise Isolation?

Usually NO.

Large enterprises typically use:
- separate AWS accounts
- separate backends
- separate pipelines

---

## Difference between tfvars and Workspaces

| Component  | Purpose                   |
| ---------- | ------------------------- |
| tfvars     | Environment configuration |
| Workspaces | State isolation           |

---

## Why combine Workspaces with lookup()?

Benefits:
- dynamic infrastructure sizing
- centralized environment management
- scalable configuration

---

# Production Reality

Terraform workspaces are useful for lightweight environment isolation, but large enterprise environments usually evolve beyond simple workspace-based architectures.

At scale organizations typically require:
- separate cloud accounts
- isolated IAM boundaries
- isolated state backends
- isolated CI/CD pipelines
- compliance separation

Workspaces remain valuable for:
- development environments
- testing
- sandbox infrastructure
- reusable infrastructure experimentation
