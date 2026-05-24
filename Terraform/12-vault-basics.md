# HashiCorp Vault Basics

# What is HashiCorp Vault?

HashiCorp Vault is a secrets management and data protection platform.

Used for:
- secret storage
- dynamic credentials
- encryption
- identity-based access
- certificate management

---

# Why Vault is Important

Without proper secret management:
- secrets get hardcoded
- credentials leak into Git
- manual rotation becomes difficult
- auditability becomes weak

Production Impact:
Poor secret management is a major security risk.

---

# Common Secrets Managed by Vault

Examples:
- AWS credentials
- database passwords
- API tokens
- SSH keys
- TLS certificates
- Kubernetes secrets

---

# Vault Architecture

```text
Client/Application
         ↓
Vault API
         ↓
Secret Engine
         ↓
Secrets / Dynamic Credentials
```

---

# Core Vault Components

| Component             | Purpose                  |
| --------------------- | ------------------------ |
| Vault Server          | Secret management engine |
| Secret Engine         | Generates/stores secrets |
| Authentication Method | Identity verification    |
| Policy                | Access control           |
| Token                 | Vault access credential  |

---

# Vault Use Cases in DevOps

Production Usage:
- Terraform authentication
- CI/CD secret injection
- dynamic database credentials
- temporary cloud credentials
- Kubernetes secret delivery

---

# Install Vault

Linux Example:
```bash
wget https://releases.hashicorp.com/vault/1.15.0/vault_1.15.0_linux_amd64.zip

unzip vault_1.15.0_linux_amd64.zip

sudo mv vault /usr/local/bin/
```

Verify:
```bash
vault version
```

---

# Start Dev Vault Server

Development Mode:
```bash
vault server -dev
```

Output Example:
```text
Root Token: hvs.xxxxx
```

Production Warning:
```text
-dev mode is NOT production-safe.
```

Used only for:
- learning
- testing
- local development

---

# Set Vault Environment Variable

Example:
```bash
export VAULT_ADDR='http://127.0.0.1:8200'
```

---

# Authenticate to Vault

Example:
```bash
vault login
```

Paste:
```text
Root Token
```

---

# Vault Status

Check Vault health:
```bash
vault status
```

---

# Enable KV Secret Engine

Command:
```bash
vault secrets enable -path=secret kv-v2
```

Purpose:
Creates key-value secret engine.

---

# Store Secret in Vault

Example:
```bash
vault kv put secret/aws \
access_key="AKIAXXXXX" \
secret_key="xxxxxxxx"
```

---

# Read Secret from Vault

Example:
```bash
vault kv get secret/aws
```

---

# Delete Secret

Example:
```bash
vault kv delete secret/aws
```

---

# Vault Authentication Methods

| Method     | Production Usage |
| ---------- | ---------------- |
| Token      | Testing          |
| AppRole    | CI/CD            |
| AWS IAM    | AWS workloads    |
| Kubernetes | K8s workloads    |
| LDAP/OIDC  | Enterprise SSO   |

---

# Production Authentication Recommendation

Avoid:
```text
Root tokens
```

Use:
- AppRole
- IAM auth
- Kubernetes auth
- OIDC/SSO

---

# Vault Policies

Vault uses policies for access control.

Example:
```hcl
path "secret/data/aws" {
  capabilities = ["read"]
}
```

Purpose:
Restricts:
- read
- write
- delete
- list

permissions.

---

# Create Vault Policy

Example:
```bash
vault policy write aws-read aws-read-policy.hcl
```

---

# Vault Tokens

Vault authentication returns:
```text
Vault Token
```

Purpose:
Used for:
- API authentication
- CLI access
- automation workflows

---

# Token Types

| Token Type    | Usage                |
| ------------- | -------------------- |
| Root Token    | Full admin access    |
| Service Token | Automation           |
| Batch Token   | High-scale workloads |

---

# Dynamic Secrets

Vault can generate temporary credentials dynamically.

Examples:
- temporary AWS IAM credentials
- temporary DB users
- temporary certificates

Production Advantage:
- automatic expiration
- reduced credential leakage
- improved security

---

# AWS Secret Engine

Enable:
```bash
vault secrets enable aws
```

Configure:
```bash
vault write aws/config/root \
access_key=AKIAXXXXX \
secret_key=xxxxxxxx \
region=ap-south-1
```

---

# Generate Dynamic AWS Credentials

Example:
```bash
vault read aws/creds/deploy-role
```

Vault generates:
```text
temporary AWS credentials
```

---

# Vault with Terraform

Terraform Provider:
```hcl
provider "vault" {
  address = "http://127.0.0.1:8200"
}
```

---

# Read Secret in Terraform

Example:
```hcl
data "vault_kv_secret_v2" "aws" {
  mount = "secret"
  name  = "aws"
}
```

Usage:
```hcl
data.vault_kv_secret_v2.aws.data["access_key"]
```

---

# Vault + AWS Provider Example

```hcl
provider "aws" {
  region     = "ap-south-1"
  access_key = data.vault_kv_secret_v2.aws.data["access_key"]
  secret_key = data.vault_kv_secret_v2.aws.data["secret_key"]
}
```

Production Warning:
Secrets may still appear inside:
```text
terraform.tfstate
```

---

# Production Secret Management Reality

Best Practice:
Terraform should NOT directly manage long-lived secrets.

Preferred:
- IAM roles
- OIDC
- temporary credentials
- workload identities

---

# Vault with CI/CD

Production Usage:
Vault commonly integrates with:
- GitHub Actions
- Jenkins
- GitLab CI
- Kubernetes
- ArgoCD

Purpose:
Inject secrets dynamically during runtime.

---

# Vault AppRole Authentication

Common for:
```text
CI/CD pipelines
```

Workflow:
```text
Pipeline
   ↓
AppRole Login
   ↓
Temporary Vault Token
   ↓
Read Secrets
```

---

# Vault Audit Logging

Enable:
```bash
vault audit enable file file_path=/var/log/vault_audit.log
```

Production Importance:
Provides:
- auditing
- compliance
- access tracking

---

# Vault Seal and Unseal

Vault protects data using:
```text
Sealing
```

When sealed:
```text
Vault inaccessible
```

Production Vault requires:
```text
Unseal Keys
```

---

# Production Vault Deployment

Production Vault should use:
- HA architecture
- integrated storage/Raft
- TLS
- auto-unseal
- monitoring
- backup strategy

---

# Common Enterprise Mistakes

| Mistake                      | Impact                |
| ---------------------------- | --------------------- |
| Hardcoding secrets           | Security exposure     |
| Using root token everywhere  | Massive risk          |
| No audit logging             | No traceability       |
| Long-lived credentials       | Credential leakage    |
| Storing secrets in Git       | Critical compromise   |
| Using dev mode in production | Severe security issue |

---

# Production Best Practices

## Use Dynamic Credentials

Prefer:
```text
temporary credentials
```

over:
```text
static secrets
```

---

## Enable Audit Logging

Mandatory for:
- compliance
- security monitoring
- incident investigation

---

## Use Least Privilege Policies

Vault policies should grant:
```text
minimal required access
```

---

## Avoid Root Tokens

Use:
- AppRole
- IAM auth
- OIDC

instead.

---

## Integrate Vault with CI/CD

Benefits:
- secure secret injection
- centralized management
- automatic rotation

---

## Encrypt Communication

Always use:
```text
TLS
```

in production Vault deployments.

---

# Interview Questions

## What is HashiCorp Vault?

Vault is a centralized secrets management and data protection platform.

---

## Why use Vault?

Benefits:
- centralized secrets
- dynamic credentials
- access control
- auditability
- automatic rotation

---

## What are Dynamic Secrets?

Temporary credentials generated on-demand with automatic expiration.

---

## Why is Vault better than hardcoded secrets?

Benefits:
- centralized management
- secure rotation
- reduced leakage
- audit tracking

---

## What is Vault AppRole used for?

Authentication mechanism commonly used for:
```text
automation and CI/CD pipelines
```

---

## Why is storing secrets in Terraform risky?

Because secrets may still exist inside:
```text
terraform.tfstate
```

---

# Production Reality

In enterprise DevOps environments secret management becomes a critical operational and security concern.

Modern infrastructure systems require:
- automated secret rotation
- centralized access control
- auditability
- temporary credentials
- workload-based authentication

Vault is widely adopted because infrastructure at scale cannot rely on:
- static credentials
- manual secret handling
- secrets stored in repositories

Production-grade DevOps engineering heavily depends on proper secrets architecture.
