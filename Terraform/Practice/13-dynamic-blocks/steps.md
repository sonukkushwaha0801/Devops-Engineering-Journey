# Steps to Execute the Task

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/13-dynamic-blocks
```

---

# Step 3: Verify Files

```bash
ls
```

Expected:
```text
provider.tf
variables.tf
terraform.tfvars
main.tf
outputs.tf
```

---

# Step 4: Initialize Terraform

```bash
terraform init
```

---

# Step 5: Validate Terraform Configuration

```bash
terraform validate
```

---

# Step 6: Format Terraform Files

```bash
terraform fmt
```

---

# Step 7: Review Dynamic Block Logic

Terraform dynamically creates:
```text
multiple ingress rules
```

using:
```hcl
dynamic "ingress"
```

Production Benefit:
```text
Reusable and scalable configuration
```

---

# Step 8: Review terraform.tfvars

Ingress ports configured dynamically:
```hcl
allowed_ports = [22, 80, 443]
```

---

# Step 9: Generate Terraform Plan

```bash
terraform plan
```

Verify:
- dynamic ingress rules
- EC2 infrastructure
- reusable logic

---

# Step 10: Apply Infrastructure

```bash
terraform apply
```

Type:
```text
yes
```

Expected:
```text
Apply complete!
```

---

# Step 11: Verify Security Group Rules

Go to:
```text
AWS Console → EC2 → Security Groups
```

Verify:
- SSH
- HTTP
- HTTPS

rules generated dynamically.

---

# Step 12: Verify Outputs

```bash
terraform output
```

---

# Step 13: Modify Allowed Ports

Edit:
```text
terraform.tfvars
```

Example:
```hcl
allowed_ports = [22, 80, 443, 8080]
```

Run:
```bash
terraform plan
```

Observe:
Terraform dynamically updates ingress rules.

---

# Step 14: Destroy Infrastructure

```bash
terraform destroy
```

Type:
```text
yes
```

---

# Important Production Concept

Dynamic blocks are heavily used in:
- security groups
- IAM policies
- load balancer rules
- Kubernetes manifests

when infrastructure configuration becomes repetitive.

---

# Common Errors

## Invalid dynamic block reference

Reason:
Wrong iterator usage.

Correct:
```hcl
ingress.value
```

---

## Invalid variable type

Reason:
Expected:
```hcl
list(number)
```

---

# Production Note

Dynamic blocks help reduce:
- repetitive Terraform code
- configuration duplication
- large static configurations

Widely used in reusable Terraform modules.
