# Terraform Modules

# What is a Module?

A Module is a reusable container of Terraform configurations.

A module can contain:
- resources
- variables
- outputs
- locals
- providers

Purpose:
- code reusability
- standardization
- scalability
- infrastructure abstraction

---

# Types of Modules

| Type         | Description                             |
| ------------ | --------------------------------------- |
| Root Module  | Current working Terraform directory     |
| Child Module | Reusable module called from root module |

---

# Why Modules are Important

Without modules:
- duplicated infrastructure code
- inconsistent deployments
- difficult maintenance
- poor scalability

Production Usage:
Modules are the foundation of:
- platform engineering
- reusable infrastructure
- enterprise Terraform architecture

---

# Basic Module Structure

```text
modules/
└── ec2/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── versions.tf
```

---

# Root Project Structure

```text
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
└── modules/
    └── ec2/
```

---

# Example EC2 Module

# modules/ec2/main.tf

```hcl
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
```

---

# modules/ec2/variables.tf

```hcl
variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}
```

---

# modules/ec2/outputs.tf

```hcl
output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
```

---

# Calling a Module

# main.tf

```hcl
module "frontend_ec2" {
  source = "./modules/ec2"

  ami_id         = "ami-0f5ee92e2d63afc18"
  instance_type  = "t3.medium"
  instance_name  = "frontend-web"
  environment    = "prod"
}
```

---

# Module Source Types

| Source Type        | Example                         |
| ------------------ | ------------------------------- |
| Local Path         | `./modules/ec2`                 |
| GitHub             | `github.com/org/repo`           |
| Terraform Registry | `terraform-aws-modules/vpc/aws` |
| S3                 | `s3::https://bucket/module.zip` |

---

# Module Initialization

Whenever:
- module added
- source changed
- version changed

Run:
```bash
terraform init
```

Terraform:
- downloads modules
- initializes dependencies
- updates lock metadata

---

# Module Outputs

Access module outputs using:

```hcl
module.<MODULE_NAME>.<OUTPUT_NAME>
```

Example:
```hcl
module.frontend_ec2.public_ip
```

---

# Multi-Environment Module Example

```hcl
module "frontend_ec2" {
  source = "./modules/ec2"

  ami_id = "ami-0f5ee92e2d63afc18"

  instance_type = lookup(
    var.instance_types,
    terraform.workspace,
    "t2.micro"
  )

  instance_name = "frontend-web"

  environment = terraform.workspace
}
```

Production Benefit:
- reusable infrastructure
- environment-aware deployments
- centralized configuration

---

# Module Versioning

Terraform Registry Example:
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
}
```

Production Importance:
Always pin module versions.

Reason:
Avoid:
- breaking changes
- unexpected behavior
- deployment instability

---

# Recommended Enterprise Module Structure

```text
modules/
│
├── vpc/
├── ec2/
├── alb/
├── security-group/
├── rds/
├── eks/
├── iam/
└── monitoring/
```

---

# Module Design Principles

# Single Responsibility

Good:
```text
ec2 module → only EC2
```

Bad:
```text
One giant module for everything
```

---

# Reusability

Modules should be:
- configurable
- environment-agnostic
- reusable

Avoid hardcoded:
- regions
- AMIs
- names
- CIDRs

---

# Scalability

Modules should support:
- multiple environments
- variable sizing
- tagging standards
- future expansion

---

# DRY Principle

Modules reduce:
```text
Duplicate Infrastructure Code
```

Benefits:
- easier maintenance
- consistency
- reduced errors

---

# count with Modules

Example:
```hcl
module "web_servers" {
  count  = 2
  source = "./modules/ec2"

  ami_id         = "ami-0f5ee92e2d63afc18"
  instance_type  = "t2.micro"
  instance_name  = "web-server"
  environment    = "dev"
}
```

---

# for_each with Modules

Example:
```hcl
module "environments" {
  for_each = var.instance_types

  source = "./modules/ec2"

  ami_id         = "ami-0f5ee92e2d63afc18"
  instance_type  = each.value
  instance_name  = each.key
  environment    = each.key
}
```

Production Recommendation:
Prefer:
```hcl
for_each
```

Reason:
Better state stability.

---

# Module Dependencies

Terraform automatically detects dependencies through:
- inputs
- outputs
- resource references

Example:
```hcl
subnet_id = module.vpc.public_subnet_id
```

---

# Module Composition

Production Pattern:
```text
VPC Module
   ↓
Security Group Module
   ↓
EC2 Module
   ↓
ALB Module
```

Benefits:
- separation of concerns
- reusable architecture
- cleaner infrastructure

---

# Module Validation

Example:
```hcl
variable "environment" {
  type = string

  validation {
    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "Invalid environment."
  }
}
```

Production Importance:
Protects reusable modules from invalid inputs.

---

# Module Locals

Example:
```hcl
locals {
  common_tags = {
    ManagedBy = "terraform"
  }
}
```

Production Usage:
- standard naming
- common tagging
- reusable expressions

---

# Common Enterprise Mistakes

| Mistake                      | Impact               |
| ---------------------------- | -------------------- |
| Giant monolithic modules     | Hard maintenance     |
| No version pinning           | Breaking deployments |
| Hardcoded values             | Poor reusability     |
| Environment-specific modules | Duplication          |
| Excessive module nesting     | Complexity           |
| Shared mutable modules       | Uncontrolled changes |

---

# Production Best Practices

## Keep Modules Small

One module:
```text
One responsibility
```

---

## Always Pin Module Versions

Especially for:
- registry modules
- external Git modules

---

## Use Variables Everywhere

Avoid:
- hardcoded regions
- hardcoded AMIs
- hardcoded tags

---

## Standardize Outputs

Common outputs:
- IDs
- ARNs
- IPs
- Names

---

## Use README per Module

Document:
- inputs
- outputs
- usage examples

---

## Separate Environment Logic

Do NOT create:
```text
ec2-dev-module
ec2-prod-module
```

Use:
```text
single reusable module + tfvars/workspaces
```

---

# Module Registry

Terraform Registry:
```text
https://registry.terraform.io
```

Popular Modules:
- VPC
- EKS
- ALB
- Security Groups

Production Note:
Review module code before using externally.

---

# Interview Questions

## What is a Terraform Module?

A reusable collection of Terraform configurations used to standardize and scale infrastructure provisioning.

---

## Why use Modules?

Benefits:
- reusability
- maintainability
- standardization
- scalability

---

## Difference between Root Module and Child Module

| Type         | Meaning                   |
| ------------ | ------------------------- |
| Root Module  | Current working directory |
| Child Module | Reusable called module    |

---

## Why pin module versions?

To:
- prevent breaking changes
- maintain deployment consistency
- ensure reproducibility

---

## Why avoid giant modules?

Problems:
- poor maintainability
- difficult debugging
- weak scalability
- tight coupling

---

## Why use outputs in modules?

Outputs expose reusable infrastructure values to other modules/resources.

---

# Production Reality

In enterprise Terraform engineering modules become the core architecture layer because:
- infrastructure grows rapidly
- teams require standardization
- environments multiply
- governance becomes critical

Well-designed modules enable:
- platform engineering
- self-service infrastructure
- scalable CI/CD
- reusable cloud patterns
- multi-environment consistency

Poor module design eventually creates:
- infrastructure sprawl
- duplicated code
- deployment instability
- maintenance bottlenecks
