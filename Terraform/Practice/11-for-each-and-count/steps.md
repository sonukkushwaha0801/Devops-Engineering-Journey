# Steps to Execute the Task

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/11-for-each-and-count
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

# Step 7: Review count Logic

Terraform uses:
```hcl
count = var.instance_count
```

Purpose:
Create multiple EC2 instances dynamically.

---

# Step 8: Review for_each Logic

Terraform uses:
```hcl
for_each = toset(var.security_groups)
```

Purpose:
Create multiple Security Groups dynamically.

---

# Step 9: Generate Terraform Plan

```bash
terraform plan
```

Verify:
- multiple EC2 instances
- multiple security groups
- indexed infrastructure

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

# Step 11: Verify EC2 Instances

Go to:
```text
AWS Console → EC2 → Instances
```

Verify:
- multiple instances created
- naming pattern correct

---

# Step 12: Verify Security Groups

Go to:
```text
AWS Console → EC2 → Security Groups
```

Verify:
- dynamically created security groups

---

# Step 13: Verify Terraform Outputs

```bash
terraform output
```

Expected:
```text
instance_ids
security_group_ids
```

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

Production teams generally prefer:
```text
for_each
```

over:
```text
count
```

Reason:
- stable resource addressing
- safer state management
- lower accidental recreation risk

---

# Common Errors

## Invalid index

Reason:
Wrong count indexing.

---

## Duplicate object key

Reason:
Duplicate for_each keys.

---

# Production Note

count and for_each are foundational for:
- scalable infrastructure
- reusable modules
- multi-environment deployments
- large-scale Terraform automation
