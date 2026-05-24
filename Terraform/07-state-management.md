# Terraform State Management

# What is Terraform State?

Terraform state is a mapping file that tracks:
- infrastructure resources
- metadata
- dependencies
- current infrastructure state

Default File:
```text
terraform.tfstate
```

Terraform uses state to:
- compare desired vs actual infrastructure
- detect changes
- manage updates
- track resources

---

# Why State is Important

Without state:
Terraform cannot reliably:
- update infrastructure
- detect drift
- manage dependencies
- identify existing resources

Terraform state acts as:
```text
Source of Truth
```

---

# Terraform State Workflow

```text
Terraform Configuration
          ↓
Terraform State
          ↓
Actual Infrastructure
```

Terraform compares:
```text
Desired State vs Current State
```

---

# State File Contents

State contains:
- resource IDs
- metadata
- dependency graph
- attributes
- outputs

Example:
```json
{
  "resources": [
    {
      "type": "aws_instance",
      "name": "frontend"
    }
  ]
}
```

---

# Default Local State

Default:
```text
terraform.tfstate
```

Stored locally in working directory.

---

# Local State Problems

| Problem                 | Impact                  |
| ----------------------- | ----------------------- |
| No collaboration        | Team conflicts          |
| No locking              | Concurrent corruption   |
| No versioning           | Recovery impossible     |
| Sensitive data exposure | Security risk           |
| State loss              | Infrastructure mismatch |

Production Verdict:
Local state is NOT suitable for teams.

---

# State Lifecycle

Terraform state updates during:
- apply
- destroy
- import
- refresh

Terraform continuously synchronizes:
```text
State ↔ Infrastructure
```

---

# State Commands

# Show State

```bash
terraform show
```

Displays:
- resources
- attributes
- outputs

---

# List Resources

```bash
terraform state list
```

Example Output:
```text
aws_instance.frontend
aws_s3_bucket.logs
```

---

# Inspect Single Resource

```bash
terraform state show aws_instance.frontend
```

Useful for:
- debugging
- attribute inspection
- dependency validation

---

# Remove Resource from State

```bash
terraform state rm aws_instance.frontend
```

Behavior:
- removes from Terraform state
- does NOT delete actual infrastructure

Production Usage:
- migration
- recovery
- broken state cleanup

---

# Move State Resource

```bash
terraform state mv old_name new_name
```

Production Usage:
- refactoring
- module migration
- renaming resources

---

# Pull Remote State

```bash
terraform state pull
```

Downloads current remote state locally.

---

# Push State

```bash
terraform state push terraform.tfstate
```

Production Warning:
Dangerous operation.

Can overwrite remote state.

---

# State Locking

Purpose:
Prevent concurrent Terraform operations.

Without locking:
- state corruption
- infrastructure inconsistency
- race conditions

Production Requirement:
Always enable locking in team environments.

---

# State Locking Example

Using:
```text
S3 + DynamoDB
```

Workflow:
```text
Terraform Apply
      ↓
Acquire Lock
      ↓
Modify State
      ↓
Release Lock
```

---

# State Drift

Drift occurs when:
```text
Actual Infrastructure ≠ Terraform State
```

Causes:
- manual console changes
- external automation
- deleted resources
- unmanaged updates

---

# Drift Example

Terraform State:
```text
EC2 instance type = t2.micro
```

Actual Infrastructure:
```text
EC2 instance type = t3.medium
```

Result:
```text
Infrastructure Drift
```

---

# Detect Drift

Command:
```bash
terraform plan
```

Terraform compares:
- configuration
- state
- actual infrastructure

---

# Refresh State

Command:
```bash
terraform refresh
```

Purpose:
Updates Terraform state using actual infrastructure.

Production Note:
Modern Terraform internally refreshes during:
```bash
terraform plan
terraform apply
```

---

# Sensitive Data in State

State may contain:
- passwords
- secrets
- tokens
- private IPs
- database endpoints

Production Risk:
State exposure = infrastructure compromise.

---

# State Security Best Practices

## Encrypt Remote State

AWS Example:
- S3 encryption enabled
- KMS encryption

---

## Restrict State Access

Use:
- IAM roles
- least privilege access
- dedicated Terraform roles

---

## Avoid Secrets in Terraform

Do NOT hardcode:
- passwords
- API keys
- tokens

Use:
- Vault
- AWS Secrets Manager
- environment variables

---

# State Backup Importance

State corruption can:
- orphan infrastructure
- break deployments
- create drift
- lose resource mapping

Production Requirement:
Always enable:
- state versioning
- backup recovery

---

# State File Lock Scenario

Without Locking:
```text
Engineer A → terraform apply
Engineer B → terraform apply
```

Possible Result:
```text
Corrupted state
```

With Locking:
```text
Only one operation allowed
```

---

# State Dependencies

Terraform stores dependency graph in state.

Example:
```text
EC2 depends on:
- subnet
- security group
```

Used for:
- ordered creation
- ordered destruction
- dependency resolution

---

# Remote State Data Source

Used to consume outputs from another state.

Example:
```hcl
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraform-state-prod"
    key    = "network/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

Usage:
```hcl
data.terraform_remote_state.network.outputs.vpc_id
```

Production Usage:
- shared infrastructure
- network/account separation
- platform architecture

---

# State File Naming Strategy

Recommended:
```text
dev/terraform.tfstate
prod/terraform.tfstate
network/terraform.tfstate
```

Avoid:
```text
single global state file
```

---

# State Splitting

Production Pattern:
Separate states for:
- networking
- compute
- IAM
- monitoring
- Kubernetes

Benefits:
- reduced blast radius
- faster plans
- team separation
- scalable operations

---

# Monolithic State Problem

One giant state causes:
- slow plans
- lock contention
- large blast radius
- difficult recovery

Production Recommendation:
Split infrastructure logically.

---

# State Recovery Scenario

If state lost:
Terraform may attempt:
```text
Recreate existing infrastructure
```

Result:
- duplication
- conflicts
- outages

Production Reality:
State backup is mission critical.

---

# Common Enterprise Mistakes

| Mistake                       | Impact             |
| ----------------------------- | ------------------ |
| Local state in teams          | State conflicts    |
| No locking                    | Corruption         |
| No versioning                 | No recovery        |
| Giant shared state            | Scalability issues |
| Manual infrastructure changes | Drift              |
| Secrets in state              | Security exposure  |

---

# Production Best Practices

## Always Use Remote Backend

Preferred:
- S3 + DynamoDB
- Terraform Cloud
- Consul

---

## Enable State Locking

Mandatory for:
- team environments
- CI/CD pipelines

---

## Enable State Versioning

Benefits:
- rollback
- recovery
- auditing

---

## Encrypt State

Protect:
- credentials
- metadata
- infrastructure mapping

---

## Split Infrastructure States

Separate:
- networking
- compute
- databases
- monitoring

---

## Restrict State Access

Only Terraform operators should access state.

---

## Never Manually Edit State

Avoid:
```text
editing terraform.tfstate manually
```

Reason:
Can corrupt infrastructure tracking.

---

# Interview Questions

## What is Terraform State?

Terraform state tracks infrastructure resources and acts as Terraform's source of truth.

---

## Why is State Important?

Terraform uses state to:
- map resources
- detect changes
- manage dependencies
- update infrastructure safely

---

## Why is Local State Bad for Teams?

Problems:
- no locking
- no collaboration
- corruption risks
- poor recovery

---

## What is State Drift?

When actual infrastructure differs from Terraform configuration/state.

Usually caused by:
- manual changes
- unmanaged automation

---

## Why is State Locking Important?

Prevents concurrent modifications and state corruption.

---

## Why Split Terraform State?

Benefits:
- scalability
- reduced blast radius
- faster operations
- better team separation

---

# Production Reality

Terraform state becomes one of the most critical operational components in enterprise infrastructure engineering.

At scale:
- state management complexity grows rapidly
- collaboration becomes difficult
- drift becomes common
- locking becomes mandatory

Real-world Terraform engineering focuses heavily on:
- remote state architecture
- locking strategy
- recovery planning
- drift prevention
- state isolation
- secure access control

Poor state management is one of the fastest ways to break production infrastructure.
