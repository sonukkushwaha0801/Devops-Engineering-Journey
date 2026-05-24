# Multi-Region and Multi-Cloud Terraform

# What is Multi-Region Infrastructure?

Multi-region infrastructure means deploying infrastructure across multiple geographical cloud regions.

Example:
```text
Mumbai     → ap-south-1
N. Virginia → us-east-1
Frankfurt  → eu-central-1
```

---

# Why Multi-Region is Important

Production Reasons:
- disaster recovery
- high availability
- low latency
- global applications
- regulatory compliance

---

# Multi-Region Architecture

Example:
```text
Primary Region   → ap-south-1
Secondary Region → us-east-1
```

Common Use Cases:
- DR environments
- failover systems
- global applications

---

# Multi-Region Provider Configuration

Terraform uses:
```hcl
provider alias
```

for multiple regions.

---

# AWS Multi-Region Provider Example

```hcl
provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}
```

---

# Resource in Secondary Region

```hcl
resource "aws_instance" "frontend_us" {
  provider = aws.us

  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = {
    Region = "us-east-1"
  }
}
```

---

# Multi-Region S3 Example

```hcl
resource "aws_s3_bucket" "india_logs" {
  bucket = "india-app-logs"
}

resource "aws_s3_bucket" "us_logs" {
  provider = aws.us

  bucket = "us-app-logs"
}
```

---

# Multi-Region Module Example

```hcl
module "frontend_india" {
  source = "./modules/ec2"

  providers = {
    aws = aws
  }

  instance_name = "frontend-india"
}
```

---

# Secondary Region Module

```hcl
module "frontend_us" {
  source = "./modules/ec2"

  providers = {
    aws = aws.us
  }

  instance_name = "frontend-us"
}
```

---

# Multi-Region Variable Mapping

Example:
```hcl
variable "region_mapping" {
  type = map(string)

  default = {
    india = "ap-south-1"
    us    = "us-east-1"
  }
}
```

---

# Region-Based Infrastructure

Example:
```hcl
provider "aws" {
  region = lookup(var.region_mapping, var.environment)
}
```

---

# Multi-Region Production Challenges

| Challenge | Impact |
|---|---|
| Data replication | Consistency issues |
| Latency | Sync delays |
| Cost | Higher infrastructure cost |
| State management | Operational complexity |
| DR testing | Failover risks |

---

# Disaster Recovery Pattern

Example:
```text
Primary Region:
ap-south-1

Backup Region:
us-east-1
```

Replication:
- S3 CRR
- database replication
- backup synchronization

---

# Active-Active vs Active-Passive

| Pattern | Description |
|---|---|
| Active-Active | Both regions serve traffic |
| Active-Passive | DR region standby |

---

# Active-Passive Example

```text
Primary:
Mumbai Region

DR:
Virginia Region
```

Production Benefit:
- lower cost
- simpler operations

---

# Active-Active Example

```text
Traffic distributed globally
```

Production Benefit:
- high availability
- low latency

Production Drawback:
- complex architecture
- higher operational overhead

---

# What is Multi-Cloud?

Multi-cloud means using multiple cloud providers simultaneously.

Example:
```text
AWS + Azure
AWS + GCP
Azure + GCP
```

---

# Why Organizations Use Multi-Cloud

Reasons:
- vendor diversification
- compliance
- pricing optimization
- service specialization
- disaster recovery

---

# Multi-Cloud Terraform Advantage

Terraform supports:
```text
Single IaC tool across multiple clouds
```

Major advantage over:
```text
Cloud-specific IaC tools
```

---

# AWS + Azure Example

```hcl
provider "aws" {
  region = "ap-south-1"
}

provider "azurerm" {
  features {}
}
```

---

# AWS EC2 Example

```hcl
resource "aws_instance" "frontend" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

---

# Azure VM Example

```hcl
resource "azurerm_linux_virtual_machine" "frontend" {
  name                = "frontend-vm"
  location            = "Central India"
  resource_group_name = "prod-rg"
  size                = "Standard_B2s"
}
```

---

# AWS + GCP Example

```hcl
provider "aws" {
  region = "ap-south-1"
}

provider "google" {
  project = "prod-project"
  region  = "asia-south1"
}
```

---

# GCP Compute Example

```hcl
resource "google_compute_instance" "frontend" {
  name         = "frontend"
  machine_type = "e2-medium"
  zone         = "asia-south1-a"
}
```

---

# Multi-Cloud Use Cases

| Use Case | Example |
|---|---|
| DR | AWS → Azure failover |
| Best Service Usage | GCP BigQuery + AWS Compute |
| Compliance | Region/provider restrictions |
| Vendor Lock Avoidance | Flexible architecture |

---

# Multi-Cloud Challenges

| Challenge | Impact |
|---|---|
| IAM differences | Complex authentication |
| Networking differences | Operational overhead |
| Monitoring fragmentation | Visibility problems |
| Billing complexity | Cost tracking issues |
| Skill requirements | Higher engineering complexity |

---

# Provider Aliasing in Multi-Cloud

Example:
```hcl
provider "aws" {
  alias  = "india"
  region = "ap-south-1"
}
```

---

# Production Multi-Cloud Architecture

Enterprise Pattern:
```text
AWS  → Primary workloads
Azure → Enterprise integrations
GCP → Analytics/ML workloads
```

---

# State Management in Multi-Region

Production Recommendation:
Separate state files for:
- regions
- environments
- cloud providers

Example:
```text
aws-prod.tfstate
azure-prod.tfstate
gcp-prod.tfstate
```

---

# Backend Strategy

Recommended:
```text
Separate remote backends
```

per:
- cloud
- environment
- platform

---

# Multi-Region Module Design

Good Module:
```text
Region-agnostic
```

Avoid:
```text
hardcoded regions
```

Example:
```hcl
variable "aws_region" {
  type = string
}
```

---

# Common Enterprise Mistakes

| Mistake | Impact |
|---|---|
| Hardcoded regions | Poor scalability |
| Single shared state | Large blast radius |
| Same IAM strategy everywhere | Security issues |
| No DR testing | Failover failures |
| Overengineering multi-cloud | Operational complexity |

---

# Production Best Practices

## Use Provider Aliases

Mandatory for:
- multi-region
- multi-account
- multi-cloud

---

## Separate States

Separate by:
- region
- environment
- provider

---

## Keep Modules Cloud-Agnostic

Avoid:
```text
hardcoded cloud assumptions
```

---

## Use DR Automation

Automate:
- failover
- replication
- backups
- validation

---

## Test Disaster Recovery

Production Requirement:
Regular DR drills.

---

## Avoid Unnecessary Multi-Cloud

Multi-cloud adds:
- operational complexity
- cost
- networking challenges

Use only when justified.

---

# Multi-Account + Multi-Region Pattern

Enterprise AWS Example:

```text
prod-account
   ├── ap-south-1
   └── us-east-1

dev-account
   ├── ap-south-1
```

Benefits:
- isolation
- security
- governance

---

# CI/CD in Multi-Region

Pipelines usually handle:
- region selection
- provider authentication
- environment promotion
- DR deployment

---

# Interview Questions

## What is Multi-Region Infrastructure?

Infrastructure deployed across multiple geographic cloud regions.

---

## Why use Multi-Region?

Benefits:
- disaster recovery
- high availability
- low latency

---

## What is Multi-Cloud?

Using multiple cloud providers simultaneously.

---

## Why is Terraform strong for Multi-Cloud?

Because Terraform supports:
```text
Unified Infrastructure as Code
```

across multiple providers.

---

## What are Provider Aliases?

Used to configure:
- multiple regions
- multiple accounts
- multiple providers

within same Terraform configuration.

---

## Why separate states in multi-region environments?

Benefits:
- reduced blast radius
- easier recovery
- scalable operations

---

## What is the biggest challenge in Multi-Cloud?

Operational complexity:
- IAM
- networking
- monitoring
- governance

---

# Production Reality

Multi-region infrastructure is common in mature production systems.

Multi-cloud is less common than beginners assume because operational complexity increases significantly.

Enterprise Terraform engineering focuses heavily on:
- provider isolation
- state separation
- DR automation
- scalable architecture
- governance controls
- reusable multi-region modules

At scale infrastructure architecture decisions become:
- operational decisions
- reliability decisions
- cost decisions
- governance decisions

not just provisioning decisions.
