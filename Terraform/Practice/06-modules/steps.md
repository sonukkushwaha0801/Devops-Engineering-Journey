# Steps to Execute the Task

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/06-modules
```

---

# Step 3: Verify Directory Structure

```bash
tree
```

Expected:
```text
06-modules/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── modules/
    └── EC2-creation/
```

---

# Step 4: Initialize Terraform

```bash
terraform init
```

Purpose:
- initialize Terraform
- download AWS provider
- initialize modules

---

# Step 5: Validate Configuration

```bash
terraform validate
```

---

# Step 6: Format Terraform Files

```bash
terraform fmt -recursive
```

Purpose:
Format root module and child modules.

---

# Step 7: Review Module Usage

Root module:
```text
calls child module
```

Child module:
```text
creates EC2 infrastructure
```

---

# Step 8: Generate Terraform Plan

```bash
terraform plan
```

Verify:
- module initialization
- EC2 resource creation
- variable injection

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

# Step 10: Verify Outputs

```bash
terraform output
```

Expected:
```text
instance_id
public_ip
```

---

# Step 11: Verify AWS Infrastructure

Go to:
```text
AWS Console → EC2 → Instances
```

Verify:
- instance running
- correct tags
- correct instance type

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

# Common Errors

## Module not installed

Fix:
```bash
terraform init
```

---

## Unsupported argument

Reason:
Variable mismatch between:
- root module
- child module

Fix:
Verify variable names carefully.

---

## Missing module output

Reason:
Output not defined in child module.

Fix:
Add output inside:
```text
modules/EC2-creation/outputs.tf
```

---

# Production Note

Modules are heavily used in enterprise Terraform for:
- reusable infrastructure
- platform engineering
- standardization
- scalable deployments
- multi-environment architecture
