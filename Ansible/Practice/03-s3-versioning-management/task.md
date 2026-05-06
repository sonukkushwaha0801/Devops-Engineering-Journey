# AWS S3 Versioning Management using Ansible

## Objective

Automate enabling versioning on AWS S3 buckets using Ansible.

---

# Tasks

## Task 1 — Configure AWS Credentials

Configure AWS CLI on the Ansible control node using IAM user credentials.

### Requirements

- Configure AWS CLI access on the control node
- Use IAM user:
  - Access Key ID
  - Secret Access Key
- Configure default AWS region
- Ensure credentials are securely configured

---

## Task 2 — Verify AWS Connectivity

Validate AWS connection from the control node.

### Requirements

- Verify access to AWS services
- Ensure S3 buckets are accessible
- Confirm AWS CLI authentication is working properly

---

## Task 3 — Enable S3 Bucket Versioning

Create an Ansible playbook to enable versioning on AWS S3 buckets.

### Requirements

- Execute playbook from control node
- Use local connection
- Fetch available S3 buckets
- Enable versioning on buckets
- Ensure automation is idempotent

---

# Notes

- Requires valid IAM permissions for S3 operations
- Inventory file is not required
- AWS CLI must be configured before execution
- Versioning helps protect objects from accidental deletion or overwrites
- This task focuses on AWS automation using Ansible modules
