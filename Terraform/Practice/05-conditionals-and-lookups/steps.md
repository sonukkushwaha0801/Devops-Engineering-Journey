# Steps to Execute the Task

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/05-conditionals-and-lookups
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

Purpose:
- initialize Terraform
- download AWS provider

---

# Step 5: Validate Configuration

```bash
terraform validate
```

---

# Step 6: Format Terraform Files

```bash
terraform fmt
```

---

# Step 7: Review terraform.tfvars

Example:
```hcl
environment = "dev"
```

---

# Step 8: Review lookup() Map

Terraform dynamically selects:
```text
instance type
```

based on:
```text
environment
```

Example Mapping:
```text
dev     → t2.micro
staging → t2.small
prod    → t3.medium
```

---

# Step 9: Generate Terraform Plan

```bash
terraform plan
```

Verify:
- selected instance type
- environment tags
- conditional backup tag

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

# Step 11: Verify Outputs

```bash
terraform output
```

Expected:
```text
instance_type
environment
public_ip
```

---

# Step 12: Modify Environment

Edit:
```text
terraform.tfvars
```

Change:
```hcl
environment = "prod"
```

---

# Step 13: Run Terraform Plan Again

```bash
terraform plan
```

Observe:
Terraform dynamically changes:
- instance type
- tags
- conditional values

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

# Common Errors

## Invalid lookup key

Reason:
Environment key missing from map.

Fix:
Ensure map contains:
```text
dev
staging
prod
```

---

## Invalid conditional expression

Reason:
Wrong Terraform syntax.

Correct Syntax:
```hcl
condition ? true : false
```

---

# Production Note

Conditionals and lookup() are heavily used in enterprise Terraform for:
- environment scaling
- DR infrastructure
- region mapping
- dynamic configuration
- reusable modules
