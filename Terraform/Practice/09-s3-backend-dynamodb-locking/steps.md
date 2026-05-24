# Steps to Execute the Task

# Architecture Flow

```text
backend-bootstrap/
        ↓
Creates:
- S3 Bucket
- DynamoDB Table

        ↓

infrastructure/
        ↓
Uses:
- S3 Backend
- DynamoDB Locking
```

---

# Important Production Concept

Terraform backend resources:
```text
MUST EXIST BEFORE
terraform init
```

Reason:
Terraform initializes backend BEFORE resource creation.

So:
```text
Backend infrastructure must be bootstrapped separately.
```

---

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Backend Bootstrap Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/09-s3-backend-dynamodb-locking/backend-bootstrap
```

---

# Step 3: Verify Backend Bootstrap Files

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

# Step 4: Initialize Backend Bootstrap

```bash
terraform init
```

---

# Step 5: Validate Configuration

```bash
terraform validate
```

---

# Step 6: Generate Plan

```bash
terraform plan
```

Verify:
- S3 bucket creation
- versioning enabled
- encryption enabled
- DynamoDB table creation

---

# Step 7: Apply Backend Bootstrap Infrastructure

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

# Step 8: Verify Backend Infrastructure

Go to:
```text
AWS Console → S3
```

Verify:
- bucket created
- versioning enabled

Check:
```text
AWS Console → DynamoDB
```

Verify:
- lock table exists

---

# Step 9: Move into Infrastructure Directory

```bash
cd ../infrastructure
```

---

# Step 10: Verify Infrastructure Files

```bash
ls
```

Expected:
```text
backend.tf
provider.tf
variables.tf
terraform.tfvars
main.tf
outputs.tf
```

---

# Step 11: Initialize Remote Backend

```bash
terraform init
```

Terraform will:
- configure S3 backend
- configure DynamoDB locking
- initialize remote state

Expected:
```text
Terraform has been successfully initialized
```

---

# Step 12: Verify Remote State in S3

Go to:
```text
AWS Console → S3 → terraform-state bucket
```

Verify:
```text
terraform.tfstate exists
```

---

# Step 13: Generate Terraform Plan

```bash
terraform plan
```

---

# Step 14: Apply Infrastructure

```bash
terraform apply
```

Type:
```text
yes
```

---

# Step 15: Verify DynamoDB Locking

During Terraform apply:
Terraform creates temporary lock inside:
```text
DynamoDB Table
```

Purpose:
Prevent concurrent Terraform operations.

---

# Step 16: Verify EC2 Infrastructure

Go to:
```text
AWS Console → EC2
```

Verify:
- instance running
- state managed remotely

---

# Step 17: Verify Remote State Commands

Command:
```bash
terraform state list
```

Purpose:
Verify state operations work with remote backend.

---

# Step 18: Destroy Infrastructure

Destroy EC2:
```bash
terraform destroy
```

---

# Step 19: Cleanup Backend Infrastructure

Move:
```bash
cd ../backend-bootstrap
```

Destroy backend resources:
```bash
terraform destroy
```

---

# Important Production Warning

Never destroy backend infrastructure while:
- active Terraform states exist
- production infrastructure depends on backend

Can result in:
- state loss
- infrastructure orphaning
- recovery complexity

---

# Common Errors

## NoSuchBucket

Reason:
S3 bucket not created yet.

Fix:
Run:
```text
backend-bootstrap first
```

---

## ResourceNotFoundException

Reason:
DynamoDB table missing.

Fix:
Verify lock table exists.

---

## Error acquiring state lock

Reason:
Another Terraform operation running.

Fix:
Wait for existing operation.

---

# Production Note

S3 backend + DynamoDB locking is one of the most common production Terraform backend architectures on AWS.

Enterprise teams heavily rely on:
- remote state
- locking
- backend isolation
- state recovery
- state versioning
- collaborative workflows
