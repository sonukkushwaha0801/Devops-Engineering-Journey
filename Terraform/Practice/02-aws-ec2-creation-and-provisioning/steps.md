# Steps to Execute the Task

# Step 1: Install Terraform

Verify:
```bash
terraform version
```

---

# Step 2: Install AWS CLI

Linux:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install
```

Verify:
```bash
aws --version
```

---

# Step 3: Configure AWS Credentials

Command:
```bash
aws configure
```

Provide:
```text
AWS Access Key ID
AWS Secret Access Key
Region
Output Format
```

Example:
```text
ap-south-1
json
```

---

# Step 4: Verify AWS Authentication

Command:
```bash
aws sts get-caller-identity
```

Expected:
```json
Account Details
```

---

# Step 5: Clone Repository

```bash
git clone <REPOSITORY_URL>
```

Move into project:
```bash
cd Devops-Engineering-Journey/Terraform/Practice/02-aws-ec2-provisioning
```

---

# Step 6: Verify Terraform Files

```bash
ls
```

Expected:
```text
provider.tf
main.tf
variables.tf
terraform.tfvars
outputs.tf
```

---

# Step 7: Initialize Terraform

```bash
terraform init
```

Purpose:
- download AWS provider
- initialize Terraform directory

---

# Step 8: Validate Configuration

```bash
terraform validate
```

---

# Step 9: Format Terraform Files

```bash
terraform fmt
```

---

# Step 10: Review Terraform Plan

```bash
terraform plan
```

Expected:
```text
Plan: 1 to add
```

---

# Step 11: Apply Infrastructure

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

# Step 12: Verify EC2 Instance

## Using AWS Console

Go to:
```text
AWS Console → EC2 → Instances
```

Verify:
- instance running
- correct instance type
- tags applied

---

# Step 13: Check Terraform Outputs

```bash
terraform output
```

Expected:
```text
instance_id
public_ip
```

---

# Step 14: SSH into EC2 (Optional)

Example:
```bash
ssh -i my-key.pem ubuntu@<PUBLIC_IP>
```

---

# Step 15: Destroy Infrastructure

```bash
terraform destroy
```

Type:
```text
yes
```

Purpose:
Remove AWS resources to avoid billing.

---

# Important AWS Billing Note

EC2 instances may incur AWS charges.

Always destroy unused infrastructure.

---

# Common Errors

## NoCredentialProviders

Reason:
AWS CLI not configured.

Fix:
```bash
aws configure
```

---

## InvalidAMIID.NotFound

Reason:
Wrong AMI ID for region.

Fix:
Use region-compatible AMI.

---

## UnauthorizedOperation

Reason:
Insufficient IAM permissions.

Fix:
Use proper IAM permissions.

---

# Production Note

This project provisions:
```text
Single EC2 Instance
```

Production environments typically use:
- Launch Templates
- Auto Scaling Groups
- ALB
- Multi-AZ deployment
- Remote Backend
- CI/CD automation
