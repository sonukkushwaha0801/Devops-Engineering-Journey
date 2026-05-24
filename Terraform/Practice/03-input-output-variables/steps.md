# Steps to Execute the Task

# Step 1: Configure AWS CLI

Verify:
```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/03-input-output-variables
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
- download AWS provider
- initialize Terraform working directory

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
aws_region     = "ap-south-1"
instance_type  = "t2.micro"
instance_name  = "terraform-variable-demo"
```

Purpose:
Store environment-specific variable values.

---

# Step 8: Generate Terraform Plan

```bash
terraform plan
```

Verify:
- EC2 instance configuration
- variable values
- resource creation

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
instance_name
```

---

# Step 11: Verify EC2 in AWS Console

Go to:
```text
AWS Console → EC2 → Instances
```

Verify:
- instance running
- correct name tag
- correct instance type

---

# Step 12: Modify Variables

Edit:
```text
terraform.tfvars
```

Example:
```hcl
instance_type = "t3.micro"
```

Run:
```bash
terraform plan
```

Observe:
Terraform detects infrastructure changes dynamically.

---

# Step 13: Destroy Infrastructure

```bash
terraform destroy
```

Type:
```text
yes
```

---

# Common Errors

## Missing required variable

Reason:
Variable value not provided.

Fix:
Add value in:
```text
terraform.tfvars
```

---

## Invalid variable type

Reason:
Wrong variable datatype.

Fix:
Verify:
```hcl
type = string
```

---

# Production Note

Variables are heavily used in production Terraform for:
- reusable modules
- environment management
- CI/CD pipelines
- scalable infrastructure
