# Task: Terraform Provisioners

# Objective

Provision AWS EC2 infrastructure using:
- file provisioner
- remote-exec provisioner
- local-exec provisioner

The task demonstrates Terraform-based remote provisioning workflows.

---

# Infrastructure Goal

Terraform should:
1. Create EC2 instance
2. Create security group
3. Upload provisioning scripts
4. Update server packages
5. Install or upgrade NGINX
6. Install or upgrade Python3
7. Store EC2 public IP locally

---

# Concepts Covered

- file provisioner
- remote-exec
- local-exec
- SSH connection block
- infrastructure bootstrapping
- remote provisioning
- conditional package installation

---

# AWS Services Used

| Service        | Purpose           |
| -------------- | ----------------- |
| EC2            | Virtual Machine   |
| Security Group | SSH + HTTP Access |

---

# Expected Result

After successful execution:
- EC2 instance should launch
- server packages should update
- NGINX should install automatically
- Python3 should install automatically
- EC2 public IP should save locally
