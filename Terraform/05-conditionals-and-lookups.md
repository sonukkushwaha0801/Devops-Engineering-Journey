# Conditionals and Lookups

# Terraform Conditional Expressions

Terraform supports conditional logic using:

```hcl
condition ? true_value : false_value
```

Purpose:
- dynamic infrastructure
- environment-based provisioning
- scalable configuration management

Production Usage:
- environment sizing
- feature toggles
- resource enable/disable
- region selection
- backup policies

---

# Basic Conditional Syntax

Example:
```hcl
variable "environment" {
  type = string
}
```

```hcl
instance_type = var.environment == "prod" ? "t3.medium" : "t2.micro"
```

Behavior:
- prod → `t3.medium`
- others → `t2.micro`

---

# EC2 Conditional Example

```hcl
resource "aws_instance" "frontend" {
  ami = "ami-0f5ee92e2d63afc18"

  instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"
}
```

Production Benefit:
- cost optimization
- standardized environments
- reduced duplication

---

# Conditional Resource Creation

Using:
```hcl
count
```

Example:
```hcl
resource "aws_instance" "monitoring" {
  count = var.enable_monitoring ? 1 : 0

  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
}
```

Behavior:
- true  → resource created
- false → resource skipped

Production Usage:
- optional infrastructure
- DR environments
- temporary environments

---

# Conditional Outputs

Example:
```hcl
output "instance_public_ip" {
  value = var.enable_public_ip ? aws_instance.web.public_ip : null
}
```

---

# Nested Conditionals

Example:
```hcl
instance_type = (
  var.environment == "prod" ?
  "t3.large" :
  var.environment == "staging" ?
  "t3.medium" :
  "t2.micro"
)
```

Production Recommendation:
Avoid deeply nested conditions.

Better Alternative:
Use maps + lookup().

---

# lookup() Function

Purpose:
Retrieve values from maps dynamically.

Syntax:
```hcl
lookup(map, key, default)
```

---

# Basic lookup() Example

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
  instance_type = lookup(var.instance_types, var.environment, "t2.micro")
}
```

Behavior:
- dynamically selects instance type
- fallback value prevents failures

---

# lookup() with terraform.workspace

Example:
```hcl
resource "aws_instance" "frontend" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = lookup(var.instance_types, terraform.workspace, "t2.micro")
}
```

Production Usage:
Environment-aware infrastructure provisioning.

---

# Map Variables

# String Map

```hcl
variable "region_mapping" {
  type = map(string)

  default = {
    india = "ap-south-1"
    us    = "us-east-1"
    eu    = "eu-west-1"
  }
}
```

Usage:
```hcl
region = lookup(var.region_mapping, "india")
```

---

# Number Map

```hcl
variable "disk_sizes" {
  type = map(number)

  default = {
    dev  = 20
    prod = 100
  }
}
```

Usage:
```hcl
volume_size = lookup(var.disk_sizes, var.environment)
```

---

# Object Map

```hcl
variable "ec2_config" {
  type = map(object({
    instance_type = string
    volume_size   = number
  }))

  default = {
    dev = {
      instance_type = "t2.micro"
      volume_size   = 20
    }

    prod = {
      instance_type = "t3.large"
      volume_size   = 100
    }
  }
}
```

Usage:
```hcl
instance_type = var.ec2_config[var.environment].instance_type
```

---

# Conditional Tags

Example:
```hcl
tags = {
  Environment = var.environment
  Backup      = var.environment == "prod" ? "enabled" : "disabled"
}
```

Production Usage:
- governance
- automation
- backup policies

---

# Conditional Security Rules

Example:
```hcl
resource "aws_security_group" "web" {

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.environment == "prod"
      ? ["10.0.0.0/16"]
      : ["0.0.0.0/0"]
  }
}
```

Production Importance:
Avoid exposing production infrastructure publicly.

---

# contains() Function

Purpose:
Check if a value exists inside a list.

Example:
```hcl
contains(["dev", "staging", "prod"], var.environment)
```

Used in:
- validations
- policy checks

---

# Conditional Validation Example

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

---

# try() Function

Purpose:
Handle missing values safely.

Example:
```hcl
instance_type = try(
  var.instance_types[var.environment],
  "t2.micro"
)
```

Production Benefit:
Prevents runtime failures.

---

# coalesce() Function

Purpose:
Returns first non-null value.

Example:
```hcl
instance_type = coalesce(var.custom_instance_type, "t2.micro")
```

Useful for:
- fallback configurations
- optional overrides

---

# Dynamic Environment Configuration Pattern

Example:
```hcl
variable "environment_config" {
  type = map(object({
    instance_type = string
    desired_size  = number
  }))

  default = {
    dev = {
      instance_type = "t2.micro"
      desired_size  = 1
    }

    prod = {
      instance_type = "t3.large"
      desired_size  = 3
    }
  }
}
```

Production Advantage:
Centralized environment management.

---

# for_each with Maps

Example:
```hcl
resource "aws_s3_bucket" "env_buckets" {
  for_each = var.region_mapping

  bucket = "${each.key}-logs-bucket"
}
```

---

# count vs for_each

| Feature              | count   | for_each |
| -------------------- | ------- | -------- |
| Uses Index           | Yes     | No       |
| Stable State         | Weak    | Strong   |
| Better for Maps      | No      | Yes      |
| Production Preferred | Limited | Yes      |

Production Recommendation:
Prefer:
```hcl
for_each
```

for scalable infrastructure.

---

# Common Enterprise Mistakes

| Mistake                     | Impact             |
| --------------------------- | ------------------ |
| Deep nested conditionals    | Poor readability   |
| Hardcoded environment logic | Poor scalability   |
| No fallback values          | Runtime failures   |
| Using count everywhere      | State instability  |
| Massive duplicated configs  | Maintenance issues |

---

# Production Best Practices

## Prefer Maps over Nested Conditionals

Bad:
```hcl
var.env == "prod" ? ...
```

Better:
```hcl
lookup(map, key)
```

Reason:
- scalable
- cleaner
- maintainable

---

## Use Fallback Values

Always:
```hcl
lookup(map, key, default)
```

Reason:
Avoid deployment failures.

---

## Centralize Environment Configurations

Store:
- instance types
- disk sizes
- scaling configs
- regions

inside structured maps.

---

## Use Validation Rules

Validate:
- regions
- environments
- instance types
- CIDR blocks

---

## Prefer for_each

Reason:
- predictable state
- stable resource indexing
- safer modifications

---

# Interview Questions

## What is a Terraform Conditional Expression?

A conditional expression dynamically selects values based on conditions.

Syntax:
```hcl
condition ? true_value : false_value
```

---

## Why use lookup()?

To dynamically retrieve values from maps safely.

---

## Why is lookup() better than nested conditionals?

Benefits:
- scalable
- cleaner code
- centralized configuration
- easier maintenance

---

## Difference between count and for_each

| Feature                | count | for_each |
| ---------------------- | ----- | -------- |
| Uses numeric index     | Yes   | No       |
| Better state stability | No    | Yes      |
| Best for maps/objects  | No    | Yes      |

---

## What problem does try() solve?

Handles missing values safely and prevents runtime errors.

---

# Production Reality

In enterprise Terraform environments conditional logic becomes critical because:
- environments differ significantly
- infrastructure must stay reusable
- teams standardize deployments
- dynamic scaling is required

Production Terraform engineering heavily depends on:
- maps
- lookup()
- structured objects
- for_each
- validation rules
- centralized configuration models

to maintain scalable and predictable infrastructure.
