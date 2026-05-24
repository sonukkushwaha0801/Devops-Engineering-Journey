# Terraform Most Asked Interview Questions

# 1. What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool by HashiCorp used to provision, manage, and automate infrastructure using declarative configuration files.

Supports:
- AWS
- Azure
- GCP
- Kubernetes
- SaaS platforms

---

# 2. Why Terraform over CloudFormation?

| Terraform                | CloudFormation        |
| ------------------------ | --------------------- |
| Multi-cloud              | AWS only              |
| Large provider ecosystem | AWS-native            |
| Better modularity        | Tight AWS integration |
| Vendor-neutral           | AWS-focused           |

Production Advantage:
Terraform standardizes infrastructure across platforms.

---

# 3. What is Terraform State?

Terraform state is the mapping file that tracks:
- infrastructure resources
- metadata
- dependencies
- current infrastructure state

Default:
```text
terraform.tfstate
```

Terraform uses state as:
```text
Source of Truth
```

---

# 4. Why is Remote Backend Important?

Benefits:
- centralized state
- collaboration
- state locking
- versioning
- recovery

Production Standard:
```text
S3 + DynamoDB
```

---

# 5. Why use DynamoDB with S3 Backend?

Purpose:
```text
State Locking
```

Prevents:
- concurrent Terraform operations
- state corruption
- infrastructure inconsistency

---

# 6. Why must S3 bucket and DynamoDB table exist before backend configuration?

Because:
```text
terraform init
```

initializes backend BEFORE Terraform creates resources.

Terraform cannot create backend infrastructure during backend initialization.

---

# 7. What is Infrastructure Drift?

When:
```text
Terraform state/configuration ≠ actual infrastructure
```

Causes:
- manual console changes
- external automation
- unmanaged modifications

---

# 8. How do you detect Drift?

Commands:
```bash
terraform plan
```

OR

```bash
terraform refresh
```

Production Pattern:
Scheduled drift detection pipelines.

---

# 9. Difference between terraform plan and terraform apply

| Command           | Purpose         |
| ----------------- | --------------- |
| `terraform plan`  | Preview changes |
| `terraform apply` | Execute changes |

Production Practice:
Always review plan before apply.

---

# 10. What are Terraform Modules?

Reusable collections of Terraform code used for:
- standardization
- scalability
- reusable infrastructure

Production Usage:
Foundation of enterprise Terraform architecture.

---

# 11. Difference between count and for_each

| Feature                | count | for_each |
| ---------------------- | ----- | -------- |
| Uses index             | Yes   | No       |
| Better state stability | No    | Yes      |
| Best for maps          | No    | Yes      |

Production Recommendation:
Prefer:
```hcl
for_each
```

---

# 12. What are Terraform Workspaces?

Workspaces allow:
```text
multiple state files
```

using same Terraform configuration.

Used for:
- dev
- staging
- prod

environment isolation.

---

# 13. Difference between tfvars and Workspaces

| Component  | Purpose                   |
| ---------- | ------------------------- |
| tfvars     | Environment configuration |
| Workspaces | State isolation           |

---

# 14. What is lookup() Function?

Used to retrieve values from maps.

Example:
```hcl
lookup(var.instance_types, terraform.workspace, "t2.micro")
```

Production Usage:
- environment configuration
- dynamic infrastructure sizing

---

# 15. Why use Provider Version Pinning?

Purpose:
- prevent breaking changes
- maintain reproducible deployments
- stabilize CI/CD pipelines

Example:
```hcl
version = "~> 5.0"
```

---

# 16. What are Provisioners?

Provisioners execute scripts:
- locally
- remotely

during infrastructure lifecycle operations.

Types:
- local-exec
- remote-exec
- file

---

# 17. Why are Provisioners considered Last Resort?

Because they:
- reduce reliability
- are hard to debug
- create non-idempotent behavior
- are not fully state-aware

Preferred Alternatives:
- cloud-init
- Ansible
- Packer

---

# 18. What does terraform import do?

Imports existing infrastructure into Terraform state management.

Example:
```bash
terraform import aws_instance.example i-xxxxxxxx
```

Production Usage:
- legacy infrastructure migration
- Terraform adoption projects

---

# 19. What does terraform refresh do?

Updates Terraform state using actual infrastructure information.

Modern Terraform performs refresh automatically during:
```bash
terraform plan
terraform apply
```

---

# 20. What is Idempotency in Terraform?

Meaning:
Repeated execution produces same infrastructure state without unnecessary changes.

Production Importance:
- stable automation
- predictable deployments
- reliable CI/CD

---

# 21. What are Meta Arguments in Terraform?

Common Meta Arguments:
- count
- for_each
- depends_on
- provider
- lifecycle

Purpose:
Control resource behavior dynamically.

---

# 22. What is create_before_destroy?

Lifecycle rule:
```hcl
lifecycle {
  create_before_destroy = true
}
```

Purpose:
Prevents downtime during replacement operations.

---

# 23. Why use prevent_destroy?

Purpose:
Protect critical infrastructure.

Example:
```hcl
prevent_destroy = true
```

Used for:
- databases
- production buckets
- backend infrastructure

---

# 24. What is a Provider in Terraform?

A Provider is a plugin that enables Terraform to communicate with:
- cloud platforms
- APIs
- SaaS services

Examples:
- AWS
- Azure
- GCP
- Kubernetes

---

# 25. Difference between Resource and Provider

| Component | Purpose               |
| --------- | --------------------- |
| Provider  | API integration       |
| Resource  | Infrastructure object |

---

# 26. What are Data Sources?

Data sources fetch existing infrastructure information.

Example:
```hcl
data "aws_ami" "ubuntu" {

}
```

Purpose:
Read infrastructure without managing it.

---

# 27. Why avoid hardcoded secrets in Terraform?

Risks:
- Git exposure
- credential leakage
- compliance violations

Use:
- Vault
- Secrets Manager
- CI/CD secret stores

---

# 28. Why is Terraform State Sensitive?

State may contain:
- passwords
- secrets
- infrastructure metadata
- internal IPs

Production Requirement:
Encrypt and restrict access.

---

# 29. What is Multi-Region Infrastructure?

Infrastructure deployed across multiple cloud regions.

Used for:
- disaster recovery
- high availability
- low latency

---

# 30. What is Multi-Cloud Infrastructure?

Using multiple cloud providers simultaneously.

Example:
```text
AWS + Azure
AWS + GCP
```

---

# 31. Why is Terraform Strong for Multi-Cloud?

Because Terraform provides:
```text
Single IaC workflow across providers
```

---

# 32. Why split Terraform State?

Benefits:
- reduced blast radius
- faster plans
- easier recovery
- scalable operations

---

# 33. Why should Terraform not manage application deployment?

Terraform focuses on:
```text
Infrastructure Provisioning
```

Better tools for deployment:
- Kubernetes
- ArgoCD
- Helm
- CI/CD pipelines

---

# 34. What is the Purpose of terraform init?

Purpose:
- download providers
- initialize backend
- initialize modules
- generate lock file

---

# 35. What is .terraform.lock.hcl?

Provider dependency lock file.

Purpose:
- deterministic deployments
- provider consistency
- reproducible environments

Production Practice:
Commit to Git.

---

# 36. Why use terraform validate?

Purpose:
Validate:
- syntax
- configuration structure

before deployment.

---

# 37. Why use terraform fmt?

Purpose:
Standardize Terraform formatting.

Production Usage:
- CI validation
- pre-commit hooks

---

# 38. What is the Biggest Challenge in Terraform at Scale?

Not resource creation.

Real challenges:
- state management
- governance
- drift control
- collaboration
- CI/CD integration
- scalable architecture

---

# 39. What are Common Enterprise Terraform Mistakes?

Examples:
- local state in teams
- hardcoded secrets
- giant monolithic states
- no locking
- manual infrastructure changes
- no module structure

---

# 40. What is Production Terraform Engineering?

Production Terraform engineering focuses on:
- operational safety
- scalable infrastructure
- governance
- automation
- collaboration
- infrastructure lifecycle management

Terraform becomes:
```text
Critical Infrastructure Platform
```

not just:
```text
Provisioning Tool
```
