# Providers and Provider Plugins

# What is a Provider?

A Provider is a Terraform plugin that enables interaction with external APIs and services.

Examples:
- AWS
- Azure
- GCP
- Kubernetes
- GitHub
- Cloudflare

Terraform itself does NOT manage infrastructure directly.

Terraform communicates through:
```text
Provider Plugins
```

---

# Provider Architecture

```text
Terraform Core
      ↓
Provider Plugin
      ↓
Cloud/API Service
```

Example:
```text
Terraform
   ↓
AWS Provider
   ↓
AWS APIs
```

---

# What are Provider Plugins?

Provider plugins are external binaries downloaded during:

```bash
terraform init
```

Stored inside:
```text
.terraform/
```

Responsibilities:
- API communication
- Resource lifecycle management
- Authentication handling
- State translation
- Infrastructure operations

---

# Why Providers are Important

Providers define:
- available resources
- available data sources
- authentication methods
- supported services

Without providers:
Terraform cannot interact with infrastructure.

---

# Basic AWS Provider Configuration

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
```

---

# required_providers Block

Defines:
- provider source
- provider version constraints

Example:
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

Production Importance:
- Prevents unexpected provider upgrades
- Maintains consistent deployments
- Ensures reproducible infrastructure

---

# Provider Version Constraints

| Constraint | Meaning                   |
| ---------- | ------------------------- |
| `= 5.0.0`  | Exact version             |
| `!= 5.0.0` | Exclude version           |
| `>= 5.0.0` | Minimum version           |
| `~> 5.0`   | Allow patch/minor updates |

Recommended:
```hcl
~> Major.Minor
```

Example:
```hcl
~> 5.0
```

---

# Provider Plugin Download Process

Triggered during:
```bash
terraform init
```

Terraform:
1. Reads provider requirements
2. Downloads plugins
3. Verifies signatures
4. Generates `.terraform.lock.hcl`

---

# .terraform.lock.hcl

Purpose:
- Locks provider versions
- Ensures deterministic deployments

Production Practice:
Commit this file to Git.

Reason:
Ensures:
- CI/CD consistency
- team-wide version stability
- reproducible environments

---

# AWS CLI Configuration (Local System)

## Install AWS CLI

Linux:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install
```

Verify:
```bash
aws --version
```

---

# Configure AWS Credentials

Command:
```bash
aws configure
```

Prompts:
```text
AWS Access Key ID
AWS Secret Access Key
Default region
Output format
```

Example:
```text
AWS Access Key ID: AKIAXXXXX
AWS Secret Access Key: xxxxxxxxx
Default region: ap-south-1 (optional)
Default output format: json (optional)
```

Stored at:
```text
~/.aws/credentials
~/.aws/config
```

---

# Verify AWS Authentication

```bash
aws sts get-caller-identity
```

Production Use:
Used for:
- identity validation
- debugging IAM issues
- CI/CD credential verification

---

# Azure Provider Configuration

## Install Azure CLI

Linux:
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

Verify:
```bash
az version
```

---

# Login to Azure

```bash
az login
```

Terraform automatically uses Azure CLI session authentication.

Example Provider:
```hcl
provider "azurerm" {
  features {}
}
```

Production Practice:
Use:
- Service Principals
- Managed Identities

Avoid:
- personal user accounts

---

# GCP Provider Configuration

## Install Google Cloud CLI

Linux:
```bash
curl https://sdk.cloud.google.com | bash
```

Restart shell:
```bash
exec -l $SHELL
```

Initialize:
```bash
gcloud init
```

Authenticate:
```bash
gcloud auth application-default login
```

Verify:
```bash
gcloud auth list
```

---

# GCP Terraform Provider

```hcl
provider "google" {
  project = "my-project"
  region  = "asia-south1"
}
```

Production Practice:
Use:
- Service Accounts
- IAM roles
- workload identity

Avoid:
- user credential authentication

---

# Kubernetes Provider Configuration

Requirements:
- kubectl
- kubeconfig

Verify cluster access:
```bash
kubectl get nodes
```

Provider:
```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
}
```

Production Practice:
Use:
- dedicated service accounts
- RBAC restrictions

---

# GitHub Provider Configuration

Example:
```hcl
provider "github" {
  token = var.github_token
  owner = "your-org"
}
```

Production Practice:
Store tokens in:
- Vault
- GitHub Secrets
- Secrets Manager

Never hardcode tokens.

---

# Multi-Provider Configuration

Example:
```hcl
provider "aws" {
  region = "ap-south-1"
}

provider "google" {
  project = "prod-project"
  region  = "asia-south1"
}
```

Terraform supports:
- Multi-cloud deployments
- Hybrid infrastructure
- SaaS integrations

---

# Multiple AWS Providers (Aliasing)

Example:
```hcl
provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}
```

Usage:
```hcl
resource "aws_instance" "web" {
  provider = aws.us
}
```

Production Use Cases:
- Disaster Recovery
- Multi-region deployments
- Global infrastructure

---

# Authentication Best Practices

## Avoid Hardcoded Credentials

Bad:
```hcl
provider "aws" {
  access_key = "xxxx"
  secret_key = "xxxx"
}
```

Reason:
- Credential leakage
- Git exposure
- Rotation difficulty

---

# Recommended Authentication Methods

## AWS
- IAM Roles
- AWS SSO
- Environment Variables
- Vault

---

## Azure
- Managed Identity
- Service Principal

---

## GCP
- Service Accounts
- Workload Identity

---

# Environment Variable Authentication

AWS Example:
```bash
export AWS_ACCESS_KEY_ID="xxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxx"
```

Production Usage:
Common in:
- CI/CD pipelines
- ephemeral environments
- automation runners

---

# Provider Dependency Locking

Generated file:
```text
.terraform.lock.hcl
```

Contains:
- provider versions
- cryptographic hashes

Production Importance:
Prevents:
- plugin tampering
- inconsistent environments

---

# Common Enterprise Mistakes

| Mistake                          | Impact                       |
| -------------------------------- | ---------------------------- |
| No provider version pinning      | Unexpected failures          |
| Hardcoded credentials            | Security risk                |
| Using root cloud account         | Severe security issue        |
| Shared admin credentials         | No auditability              |
| Ignoring lock file               | Non-reproducible deployments |
| Manual authentication everywhere | Poor automation              |

---

# Production Best Practices

## Pin Provider Versions

Always:
```hcl
version = "~> 5.0"
```

---

## Use Least Privilege IAM

Terraform should only have:
- required permissions
- scoped access

Avoid:
```text
AdministratorAccess
```

---

## Use Dedicated Terraform IAM Roles

Recommended:
```text
terraform-dev-role
terraform-prod-role
```

Benefits:
- auditing
- separation of duties
- environment isolation

---

## Separate Provider Configurations

Use:
- environment-specific variables
- separate backend configs
- separate credentials

---

## Use CI/CD Authentication

Preferred:
- OIDC
- IAM Roles
- temporary credentials

Avoid:
- static access keys in pipelines

---

# Interview Questions

## What is a Terraform Provider?

A provider is a plugin that enables Terraform to interact with external APIs and infrastructure platforms.

---

## Why use provider version pinning?

To:
- prevent breaking changes
- ensure consistent deployments
- maintain reproducibility

---

## What happens during `terraform init`?

Terraform:
- downloads providers
- initializes backend
- installs modules
- generates lock file

---

## Difference between Provider and Resource

| Component | Purpose               |
| --------- | --------------------- |
| Provider  | API integration       |
| Resource  | Infrastructure object |

Example:
```text
Provider → AWS
Resource → EC2 Instance
```

---

## Why avoid hardcoded credentials?

Risks:
- credential leaks
- Git exposure
- poor rotation
- compliance violations

---

# Production Reality

In enterprise environments provider management becomes critical because:
- providers evolve rapidly
- APIs change frequently
- authentication standards change
- multi-account infrastructure scales complexity

Poor provider management can break:
- CI/CD pipelines
- production deployments
- infrastructure reproducibility
- compliance posture
