# Steps to Execute the Task

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/12-locals-and-tagging
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
locals.tf
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

# Step 7: Review locals.tf

Terraform locals centralize:
- tags
- naming
- reusable values

Production Benefit:
```text
Single source of reusable logic
```

---

# Step 8: Generate Terraform Plan

```bash
terraform plan
```

Verify:
- centralized tags
- standardized naming
- reusable values

---

# Step 9: Apply Infrastructure

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

# Step 10: Verify Infrastructure Tags

Go to:
```text
AWS Console → EC2
```

Verify:
- consistent tags
- standardized naming

---

# Step 11: Verify Outputs

```bash
terraform output
```

---

# Step 12: Destroy Infrastructure

```bash
terraform destroy
```

Type:
```text
yes
```

---

# Important Production Concept

Enterprise Terraform heavily relies on:
```text
locals {}
```

for:
- centralized tagging
- naming conventions
- reusable expressions
- environment standardization

---

# Common Errors

## Duplicate local value

Reason:
Same local name defined multiple times.

---

## Invalid reference

Reason:
Wrong local reference.

Correct:
```hcl
local.common_tags
```

---

# Production Note

Centralized tagging is critical for:
- cost tracking
- governance
- automation
- monitoring
- auditing

Most mature Terraform platforms enforce:
- mandatory tagging
- naming conventions
- standardized metadata
