# Steps to Execute the Task

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/07-state-management
```

---

# Step 3: Verify Files

```bash
ls
```

Expected:
```text
provider.tf
main.tf
outputs.tf
terraform.tfvars
backend.tf
```

---

# Step 4: Initialize Terraform

```bash
terraform init
```

Purpose:
- initialize Terraform
- initialize backend
- download provider plugins

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

# Step 7: Generate Terraform Plan

```bash
terraform plan
```

Expected:
```text
Plan: 1 to add
```

---

# Step 8: Apply Infrastructure

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

# Step 9: Verify Terraform State File

Command:
```bash
ls
```

Expected:
```text
terraform.tfstate
```

Purpose:
Terraform stores infrastructure metadata inside:
```text
terraform.tfstate
```

---

# Step 10: Inspect Terraform State

Command:
```bash
terraform show
```

Purpose:
Display:
- infrastructure attributes
- resource metadata
- outputs

---

# Step 11: List State Resources

Command:
```bash
terraform state list
```

Expected:
```text
aws_instance.frontend
```

---

# Step 12: Inspect Single Resource

Command:
```bash
terraform state show aws_instance.frontend
```

Purpose:
View detailed resource metadata.

---

# Step 13: Rename Resource in State

Open:
```text
main.tf
```

Change:
```hcl
resource "aws_instance" "frontend"
```

To:
```hcl
resource "aws_instance" "web"
```

---

# Step 14: Move State Mapping

Command:
```bash
terraform state mv aws_instance.frontend aws_instance.web
```

Purpose:
Move Terraform state mapping safely without recreating infrastructure.

---

# Step 15: Verify Updated State

```bash
terraform state list
```

Expected:
```text
aws_instance.web
```

---

# Step 16: Remove Resource from State

Command:
```bash
terraform state rm aws_instance.web
```

Purpose:
Remove resource from Terraform state only.

Important:
```text
Actual EC2 instance will still exist in AWS.
```

---

# Step 17: Verify AWS Console

Go to:
```text
AWS Console → EC2 → Instances
```

Observe:
```text
Instance still exists
```

---

# Step 18: Destroy Infrastructure

Since state removed:
Terraform can no longer manage resource.

Delete manually from:
```text
AWS Console
```

OR re-import infrastructure.

---

# Common Errors

## Invalid target address

Reason:
Wrong resource name.

Fix:
Verify:
```bash
terraform state list
```

---

## State lock issue

Reason:
Concurrent Terraform operation.

Fix:
Wait or release lock carefully.

---

## Resource already exists

Reason:
Terraform lost state mapping.

Fix:
Use:
```bash
terraform import
```

---

# Production Note

Terraform state is one of the most critical components in enterprise Terraform engineering.

Production teams heavily focus on:
- remote backend
- state locking
- state recovery
- drift management
- state isolation
