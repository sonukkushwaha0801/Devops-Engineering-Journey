# Variables and tfvars

# What are Variables?

Variables are used to parameterize Terraform configurations.

They help:
- avoid hardcoding
- reuse infrastructure
- separate environments
- improve scalability
- standardize deployments

Production Usage:
Variables are heavily used for:
- multi-environment infrastructure
- reusable modules
- CI/CD pipelines
- enterprise configuration management

---

# Input Variable Syntax

Basic Syntax:
```hcl
variable "instance_type" {
  description = "description of the vaiable"
  type = "type of varable"
  default ="Incase, no value passed, then use this value."
}
```

---

# Variable Components

| Argument      | Purpose              | Required                 |
| ------------- | -------------------- | ------------------------ |
| `description` | Variable explanation | Optional                 |
| `type`        | Data type validation | Optional but recommended |
| `default`     | Default value        | Optional                 |

---

# Input Variable Example

```hcl
variable "instance_type" {
  description = "EC2 instance type for frontend servers"
  type        = string
  default     = "t2.micro"
}
```

Production Recommendation:
Always use:
- description
- type

Reason:
- readability
- validation
- maintainability

---

# Using Variables in Resources

Example:
```hcl
resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
}
```

Variable Reference:
```hcl
var.<VARIABLE_NAME>
```

---

# Variables Without Default

Example:
```hcl
variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}
```

Behavior:
Terraform asks value during runtime.

---

# Variable Priority Order

Terraform loads variable values in this order:

| Priority | Source                |
| -------- | --------------------- |
| Highest  | CLI `-var`            |
| 2        | `.auto.tfvars`        |
| 3        | `terraform.tfvars`    |
| 4        | Environment Variables |
| Lowest   | default values        |

---

# terraform.tfvars

Used to store variable values separately.

Example:
```hcl
instance_type = "t3.medium"
ami_id        = "ami-0f5ee92e2d63afc18"
```

Purpose:
- cleaner code
- environment separation
- easier management

---

# Custom tfvars File

Example:
```text
prod.tfvars
dev.tfvars
staging.tfvars
```

Usage:
```bash
terraform apply -var-file="prod.tfvars"
```

Production Practice:
Use separate tfvars per environment.

---

# Environment-Based tfvars Example

## dev.tfvars

```hcl
instance_type = "t2.micro"
environment   = "dev"
```

---

## prod.tfvars

```hcl
instance_type = "t3.medium"
environment   = "prod"
```

---

# Variable Types

# String

```hcl
variable "region" {
  type    = string
  default = "ap-south-1"
}
```

---

# Number

```hcl
variable "instance_count" {
  type    = number
  default = 2
}
```

---

# Boolean

```hcl
variable "enable_monitoring" {
  type    = bool
  default = true
}
```

---

# List

```hcl
variable "availability_zones" {
  type = list(string)

  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}
```

---

# Map

```hcl
variable "instance_types" {
  type = map(string)

  default = {
    dev     = "t2.micro"
    staging = "t2.small"
    prod    = "t3.medium"
  }
}
```

Production Usage:
Commonly used for:
- environment configurations
- tagging standards
- region mappings
- instance sizing

---

# Object Type

```hcl
variable "ec2_config" {
  type = object({
    instance_type = string
    volume_size   = number
    monitoring    = bool
  })

  default = {
    instance_type = "t3.medium"
    volume_size   = 20
    monitoring    = true
  }
}
```

Production Usage:
Useful for:
- module inputs
- structured infrastructure configuration

---

# lookup() Function

Used to retrieve values from maps.

Syntax:
```hcl
lookup(map, key, default_value)
```

---

# lookup() Example

## Variable

```hcl
variable "instance_types" {
  type = map(string)

  default = {
    dev     = "t2.micro"
    staging = "t2.small"
    prod    = "t3.medium"
  }
}
```

---

## Resource

```hcl
resource "aws_instance" "frontend" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = lookup(var.instance_types, terraform.workspace, "t2.micro")
}
```

Behavior:
- picks instance type based on workspace
- fallback value = `t2.micro`

Production Use Cases:
- environment-specific configs
- region mapping
- cost optimization

---

# Variable Validation

Example:
```hcl
variable "environment" {
  type = string

  validation {
    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "Environment must be dev, staging, or prod."
  }
}
```

Production Importance:
Prevents:
- invalid deployments
- misconfigurations
- unsafe infrastructure changes

---

# Sensitive Variables

Example:
```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

Purpose:
Prevents value display in Terraform output.

Production Note:
Sensitive variables are still stored in state.

Use:
- Vault
- Secrets Manager
- CI/CD secret stores

for actual secret management.

---

# Environment Variables

Terraform supports environment variables.

Example:
```bash
export TF_VAR_instance_type="t3.medium"
```

Terraform automatically loads:
```text
TF_VAR_<variable_name>
```

Production Usage:
Common in:
- CI/CD pipelines
- GitHub Actions
- Jenkins
- GitLab CI

---

# Local Values (locals)

Used for reusable internal expressions.

Example:
```hcl
locals {
  common_tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

Usage:
```hcl
tags = local.common_tags
```

Production Benefit:
- reduces duplication
- standardizes configuration

---

# Output Variables

Used to expose infrastructure values.

Example:
```hcl
output "public_ip" {
  value = aws_instance.frontend.public_ip
}
```

View:
```bash
terraform output
```

---

# Common Enterprise Mistakes

| Mistake                        | Impact                |
| ------------------------------ | --------------------- |
| Hardcoded values               | Poor scalability      |
| No variable validation         | Invalid deployments   |
| Secrets inside tfvars          | Security risk         |
| Giant variable files           | Poor maintainability  |
| No typing                      | Runtime errors        |
| Using same tfvars for all envs | Environment conflicts |

---

# Production Best Practices

## Always Define Type

Bad:
```hcl
variable "instance_type" {}
```

Good:
```hcl
variable "instance_type" {
  type = string
}
```

---

## Use Descriptions

Reason:
- documentation
- module usability
- maintainability

---

## Separate Environment Configurations

Recommended:
```text
dev.tfvars
staging.tfvars
prod.tfvars
```

---

## Never Store Secrets in Git

Avoid:
```text
db_password = "admin123"
```

Use:
- Vault
- AWS Secrets Manager
- CI/CD secrets

---

## Use locals for Shared Values

Useful for:
- common tags
- naming conventions
- reusable expressions

---

## Use Validation Rules

Especially for:
- environments
- CIDR ranges
- instance types
- regions

---

# Module Input Variables

Example:
```hcl
module "ec2" {
  source = "./modules/ec2"

  instance_type = "t3.medium"
  environment   = "prod"
}
```

Purpose:
Makes modules reusable and configurable.

---

# terraform init with Modules

When modules are added/changed:
```bash
terraform init
```

Reason:
Terraform downloads and initializes modules.

Production Note:
Always re-run:
```bash
terraform init
```

after:
- module source changes
- backend changes
- provider updates

---

# Interview Questions

## Why use Variables in Terraform?

Benefits:
- reusability
- scalability
- environment separation
- cleaner infrastructure code

---

## Difference between Variable and Local

| Component | Purpose                      |
| --------- | ---------------------------- |
| Variable  | External input               |
| Local     | Internal reusable expression |

---

## Why use tfvars files?

To:
- separate environment configuration
- avoid hardcoding
- simplify deployments

---

## What does lookup() do?

Retrieves values from maps with optional fallback values.

---

## Why define variable types?

Benefits:
- validation
- predictability
- error prevention

---

## Why are sensitive variables still risky?

Because values still exist inside:
```text
terraform.tfstate
```

---

# Production Reality

In enterprise environments variable architecture becomes critical because:
- infrastructure spans multiple environments
- teams share reusable modules
- CI/CD pipelines inject dynamic configuration
- governance requires standardization

Poor variable design leads to:
- infrastructure drift
- environment inconsistency
- security risks
- deployment failures
- unmaintainable Terraform code
