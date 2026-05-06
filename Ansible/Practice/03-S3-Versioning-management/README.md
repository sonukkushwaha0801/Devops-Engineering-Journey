# AWS S3 Versioning Management using Ansible

This project automates enabling versioning on AWS S3 buckets using Ansible.

---

# Features

- Configure AWS CLI authentication
- Verify AWS connectivity from control node
- Fetch available S3 buckets
- Enable versioning on S3 buckets
- Practice AWS automation using Ansible modules

---

# Project Structure

⚠️ WARNING BEFORE RUNNING

You are only provided with:
- Ansible playbook
- Task description file

All remaining required configurations must be completed manually before execution.

If missing:
- AWS CLI configuration → authentication will fail
- IAM permissions → S3 operations will fail
- Python AWS dependencies → playbook execution will fail

---

## Expected Structure

```text
03-s3-versioning-management/
├── enable-s3-versioning.yaml
├── task.md
└── README.md
```

---

# Prerequisites

## 1. Control Node Requirements

Install:
- Python3
- Ansible
- AWS CLI
- boto3
- botocore

---

## Install Ansible

```bash
sudo apt update
sudo apt install ansible -y
```

---

## Install AWS CLI

```bash
sudo apt install awscli -y
```

---

## Install AWS Python Dependencies

```bash
pip install boto3 botocore
```

---

## Verify Installation

```bash
ansible --version
python3 --version
aws --version
pip show boto3
```

---

# AWS Requirements

- AWS Account
- IAM User
- AWS Access Key ID
- AWS Secret Access Key
- S3 permissions for:
  - Bucket listing
  - Bucket versioning operations

---

# Configure AWS CLI

Configure AWS credentials on the control node:

```bash
aws configure
```

Provide:
- AWS Access Key ID
- AWS Secret Access Key
- Default region
- Output format

---

# Verify AWS Connectivity

```bash
aws s3 ls
```

Expected:
- List of accessible S3 buckets

---

# Playbook Execution

## Enable S3 Bucket Versioning

```bash
ansible-playbook enable-s3-versioning.yaml
```

---

# Notes

- Playbook uses `connection: local`
- Inventory file is not required
- S3 bucket listing is globally accessible
- Bucket versioning helps recover overwritten or deleted objects
- AWS CLI must be configured before playbook execution

---

# Author

**ZENITHRA aka Sonu Kumar Kushwaha**

Open for updates and improvements.

In case of any errors/issues, please connect via GitHub profile:

🔗 https://github.com/sonukkushwaha0801
