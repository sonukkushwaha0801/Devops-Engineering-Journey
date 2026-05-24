# Terraform Import and Refresh

# What is Terraform Import?

Terraform Import is used to bring existing infrastructure under Terraform state management.

Used when infrastructure already exists:
- manually created resources
- legacy infrastructure
- console-created resources
- unmanaged cloud resources

---

# Why Import is Important

Production Reality:
Most enterprise environments already have:
- existing infrastructure
- manually managed resources
- legacy cloud environments

Terraform import enables:
- infrastructure migration
- IaC adoption
- centralized management
- drift visibility

---

# Import Workflow

```text
Existing Infrastructure
          ↓
Terraform Import
          ↓
Terraform State
          ↓
Terraform Management
```

---

# Important Production Reality

Import:
```text
ONLY imports state
```

Terraform does NOT automatically create clean Terraform code for imported infrastructure.

Meaning:
You still need:
- resource definitions
- refactoring
- modularization
- cleanup

---

# Terraform Import Requirements

Before import:
Terraform must already know:
- provider configuration
- target resource block

---

# Basic Import Configuration

Example:
```hcl
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami = "ami-0ad737a8b58b3fb92"
  instance_type = "t3.micro"
}
```

---

# Import Command

Syntax:
```bash
terraform import <RESOURCE_TYPE.NAME> <RESOURCE_ID>
```

Example:
```bash
terraform import aws_instance.example i-0abc123456789xyz
```

Behavior:
- imports resource into state
- maps existing infrastructure
- does NOT modify infrastructure

---

# Verify Imported Resources

Command:
```bash
terraform state list
```

Example Output:
```text
aws_instance.example
```

---

# Inspect Imported Resource

Command:
```bash
terraform state show aws_instance.example
```

Purpose:
- inspect attributes
- generate Terraform configuration manually
- validate import success

---

# Import Block (Modern Terraform)

Terraform supports:
```hcl
import {}
```

block-based imports.

---

# Import Block Example

```hcl
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {

}

import {
  id = "i-0abc123456789xyz"
  to = aws_instance.example
}
```

---

# Generate Terraform Configuration Automatically

Command:
```bash
terraform plan -generate-config-out=generated.tf
```

Purpose:
Terraform generates resource configuration from imported infrastructure.

Generated:
```text
generated.tf
```

Production Benefit:
Speeds up migration of legacy infrastructure.

---

# Full Modern Import Workflow

## Step 1
Define provider.

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

---

## Step 2
Define empty resource.

```hcl
resource "aws_instance" "example" {

}
```

---

## Step 3
Add import block.

```hcl
import {
  id = "i-0abc123456789xyz"
  to = aws_instance.example
}
```

---

## Step 4
Generate configuration.

```bash
terraform plan -generate-config-out=generated.tf
```

---

## Step 5
Review generated configuration carefully.

Production Requirement:
Generated configuration is NOT production-ready automatically.

Needs:
- cleanup
- modularization
- tagging
- variable extraction

---

# Importing AWS Resources

# Import EC2 Instance

```bash
terraform import aws_instance.example i-0abc123456789xyz
```

---

# Import S3 Bucket

```bash
terraform import aws_s3_bucket.logs prod-app-logs
```

---

# Import Security Group

```bash
terraform import aws_security_group.web sg-0123456789abcd
```

---

# Import IAM Role

```bash
terraform import aws_iam_role.app_role app-role
```

---

# Import Elastic IP

```bash
terraform import aws_eip.static_eip eipalloc-0123456789
```

---

# Importing Azure Resources

# Import Azure VM

```bash
terraform import azurerm_linux_virtual_machine.vm \
/subscriptions/xxxxx/resourceGroups/prod-rg/providers/Microsoft.Compute/virtualMachines/frontend-vm
```

---

# Importing GCP Resources

# Import GCP Compute Instance

```bash
terraform import google_compute_instance.vm \
projects/project-id/zones/asia-south1-a/instances/frontend-vm
```

---

# terraform refresh

Command:
```bash
terraform refresh
```

Purpose:
Updates Terraform state using actual infrastructure.

---

# Refresh Workflow

```text
Infrastructure
      ↓
Terraform Refresh
      ↓
Updated State
```

---

# Refresh Example

Before Refresh:
```text
State → t2.micro
Actual Infra → t3.medium
```

After:
```bash
terraform refresh
```

State becomes:
```text
t3.medium
```

---

# Modern Terraform Behavior

Modern Terraform automatically refreshes during:
```bash
terraform plan
terraform apply
```

Meaning:
Explicit:
```bash
terraform refresh
```

is less commonly required now.

---

# Refresh Risks

Refresh updates:
```text
Terraform state
```

without changing infrastructure.

Danger:
Drift may become accepted unintentionally.

Production Recommendation:
Always review:
```bash
terraform plan
```

carefully after refresh.

---

# Import + Drift Detection

After import:
Always run:
```bash
terraform plan
```

Purpose:
Detect:
- unmanaged attributes
- missing configurations
- drift
- unexpected changes

---

# Common Import Problem

Imported resource:
```text
Exists in state
```

But Terraform config:
```text
Incomplete
```

Result:
```bash
terraform plan
```

shows:
```text
resource replacement/modification
```

---

# Production Migration Workflow

Enterprise Migration Pattern:

```text
1. Import Existing Infra
2. Generate Configuration
3. Refactor Configuration
4. Convert to Modules
5. Validate with terraform plan
6. Enable CI/CD
```

---

# Import State Refactoring

After import:
Resources often need:
- renaming
- module migration
- tagging standardization
- variable extraction

Useful Command:
```bash
terraform state mv
```

Example:
```bash
terraform state mv aws_instance.example module.ec2.aws_instance.this
```

---

# Import Limitations

Terraform Import:
- imports state
- does NOT import:
  - comments
  - architecture intent
  - clean modular structure
  - best practices

---

# Importing into Modules

Example:
```bash
terraform import module.ec2.aws_instance.this i-0abc123456789xyz
```

Production Usage:
Used heavily during:
- infrastructure migration
- Terraform adoption projects

---

# Common Enterprise Mistakes

| Mistake                              | Impact                       |
| ------------------------------------ | ---------------------------- |
| Importing without reviewing plan     | Unexpected changes           |
| Direct production apply after import | Downtime risk                |
| No modular refactor                  | Poor maintainability         |
| Accepting generated config blindly   | Technical debt               |
| Ignoring drift after import          | Infrastructure inconsistency |

---

# Production Best Practices

## Always Backup State Before Import

Reason:
Import modifies Terraform state directly.

---

## Use Generated Config as Starting Point Only

Generated code often contains:
- unnecessary attributes
- provider defaults
- poor formatting

Needs cleanup.

---

## Validate with terraform plan

Mandatory after:
- import
- refresh
- state migration

---

## Refactor into Modules

Avoid:
```text
large flat imported infrastructure
```

---

## Import in Non-Production First

Practice migration workflow safely before production rollout.

---

## Use Version Control During Migration

Track:
- imports
- state changes
- refactoring
- drift cleanup

---

# Interview Questions

## What does Terraform Import do?

Terraform Import maps existing infrastructure into Terraform state management.

---

## Does Import Create Terraform Code Automatically?

Traditional import:
```text
NO
```

Modern Terraform:
```bash
terraform plan -generate-config-out
```

can generate starter configuration.

---

## Why is terraform plan important after import?

To detect:
- drift
- missing attributes
- replacement risks
- configuration mismatches

---

## What does terraform refresh do?

Updates Terraform state using actual infrastructure information.

---

## Why is Import Important in Enterprises?

Because most organizations already have:
- existing infrastructure
- manually managed cloud resources
- legacy environments

---

## Why is Import Risky?

Incorrect imports can:
- corrupt state
- trigger replacements
- modify production unexpectedly

---

# Production Reality

Terraform import is one of the most important enterprise Terraform skills because real organizations rarely start with greenfield infrastructure.

Most enterprise Terraform engineering involves:
- infrastructure migration
- legacy environment onboarding
- drift cleanup
- state refactoring
- modularization

Production Terraform migration projects require:
- careful planning
- dependency mapping
- state management expertise
- zero-downtime strategy
- extensive validation

Poor import strategy can break production infrastructure quickly.
