# Steps to Execute the Task

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/10-provisioners
```

---

# Step 3: Verify Directory Structure

```bash
tree
```

Expected:
```text
10-provisioners/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── scripts/
```

---

# Step 4: Verify AWS Key Pair Exists

```bash
aws ec2 describe-key-pairs
```

Verify:
```text
terraform-practice-key
```

exists.

---

# Step 5: Verify PEM File Exists

Example:
```text
terraform-practice-key.pem
```

Set permission:
```bash
chmod 400 terraform-practice-key.pem
```

---

# Step 6: Initialize Terraform

```bash
terraform init
```

---

# Step 7: Validate Terraform Configuration

```bash
terraform validate
```

---

# Step 8: Format Terraform Files

```bash
terraform fmt -recursive
```

---

# Step 9: Generate Terraform Plan

```bash
terraform plan
```

Verify:
- EC2 creation
- security group
- provisioners
- remote provisioning

---

# Step 10: Apply Infrastructure

```bash
terraform apply
```

Type:
```text
yes
```

Terraform will:
1. create EC2
2. upload scripts
3. execute scripts remotely
4. install packages
5. save public IP locally

---

# Step 11: Verify Local Output File

```bash
cat public_ip.txt
```

Expected:
```text
EC2 Public IP
```

---

# Step 12: Verify NGINX

Open Browser:
```text
http://<PUBLIC_IP>
```

Expected:
```text
NGINX Welcome Page
```

---

# Step 13: SSH into EC2

```bash
ssh -i terraform-practice-key.pem ubuntu@<PUBLIC_IP>
```

Verify:
```bash
nginx -v

python3 --version
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

# Common Errors

## SSH timeout

Reason:
- security group issue
- instance not fully booted
- wrong key pair

---

## Permission denied (publickey)

Reason:
Wrong PEM file.

---

## remote-exec failed

Reason:
EC2 still initializing.

Fix:
Retry apply after server becomes reachable.

---

# Production Note

Provisioners are considered:
```text
Last Resort
```

Production teams usually prefer:
- cloud-init
- Ansible
- Packer
- Kubernetes bootstrap workflows

Provisioners are still useful for:
- lightweight bootstrapping
- quick automation
- migration tasks
