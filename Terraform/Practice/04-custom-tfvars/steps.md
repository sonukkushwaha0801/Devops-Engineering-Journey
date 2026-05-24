# Steps to Execute the Task

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/04-custom-tfvars
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
dev.tfvars
prod.tfvars
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

# Step 7: Review tfvars Files

## dev.tfvars

```hcl
instance_type = "t2.micro"
environment   = "dev"
```

---

## prod.tfvars

```hcl
instance_type = "t3.medium"
environment   = "prod"
```

---

# Step 8: Generate Plan for Dev Environment

```bash
terraform plan -var-file="dev.tfvars"
```

Verify:
- instance type
- tags
- environment values

---

# Step 9: Apply Dev Environment

```bash
terraform apply -var-file="dev.tfvars"
```

Type:
```text
yes
```

---

# Step 10: Verify Dev Infrastructure

Check:
```bash
terraform output
```

Verify AWS Console:
```text
EC2 → Instances
```

---

# Step 11: Destroy Dev Infrastructure

```bash
terraform destroy -var-file="dev.tfvars"
```

---

# Step 12: Deploy Production Environment

Generate plan:
```bash
terraform plan -var-file="prod.tfvars"
```

Apply:
```bash
terraform apply -var-file="prod.tfvars"
```

---

# Step 13: Compare Environments

Observe:
- different instance types
- different tags
- different environment naming

using same Terraform codebase.

---

# Step 14: Destroy Production Infrastructure

```bash
terraform destroy -var-file="prod.tfvars"
```

---

# Common Errors

## No value for required variable

Reason:
Missing variable in tfvars file.

Fix:
Add required variables inside:
```text
dev.tfvars
prod.tfvars
```

---

## Wrong variable file

Reason:
Incorrect tfvars filename passed.

Fix:
Verify:
```bash
-var-file="dev.tfvars"
```

---

# Production Note

Custom tfvars files are heavily used in enterprise Terraform for:
- environment separation
- reusable infrastructure
- CI/CD deployments
- scalable configuration management
