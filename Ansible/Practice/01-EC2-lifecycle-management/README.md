# EC2 Lifecycle Management using Ansible

This project automates AWS EC2 lifecycle operations using Ansible.

---

# Features

- Create multiple EC2 instances using Ansible loops
- Configure passwordless SSH authentication
- Shutdown Ubuntu instances only using Ansible conditionals
- Use AWS EC2 Ansible modules
- Practice infrastructure automation workflows

---

# Project Structure

⚠️ WARNING BEFORE RUNNING

You are only provided with:
- Playbooks
- Inventory file
- Task description file

All remaining required files must be manually configured before execution.

Missing configuration will cause:

- `.pem` key → SSH connection failure
- AWS credentials → EC2 provisioning failure
- Incorrect inventory configuration → remote task execution failure

Update the `hosts-prod.ini` file with your managed node details.

> Important: Before running the playbook, manually connect to all managed nodes at least once via SSH and verify access using the `.pem` key.

---

## Expected Structure

```text
01-ec2-lifecycle-management/
├── create-ec2-instances.yaml
├── shutdown-ubuntu-instances.yaml
├── hosts-prod.ini
├── task.md
└── README.md
```

---

# Prerequisites

## 1. Control Node Requirements

Install:
- Python3
- Ansible
- AWS Python dependencies

---

## Install Ansible

```bash
sudo apt update
sudo apt install ansible -y
```

---

## Install AWS Dependencies

```bash
pip install boto3 botocore
```

---

## Verify Installation

```bash
ansible --version
python3 --version
```

---

# AWS Requirements

- AWS Account
- IAM User with EC2 permissions
- AWS Access Key
- AWS Secret Key
- Existing AWS EC2 Key Pair

---

# Inventory Configuration

`hosts-prod.ini` is required only for remote management playbooks.

Example:

```ini
[ubuntu]
13.xx.xx.xx ansible_user=ubuntu

[centos]
43.xx.xx.xx ansible_user=ec2-user

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

---

# SSH Passwordless Authentication

Copy SSH key to remote servers:

```bash
ssh-copy-id -o "IdentityFile <.pem>" ubuntu@<IPv4>
```

Example:

```bash
ssh-copy-id -o "IdentityFile ansible_master.pem" ubuntu@13.xx.xx.xx
```

---

# Test Ansible Connectivity

```bash
ansible all -i hosts-prod.ini -m ping
```

Expected Output:

```text
SUCCESS
```

---

# Playbook Execution

## Create EC2 Instances

```bash
ansible-playbook create-ec2-instances.yaml --vault-password-file vault.pass
```

---

## Shutdown Ubuntu Instances

```bash
ansible-playbook -i hosts-prod.ini shutdown-ubuntu-instances.yaml
```

---

# Notes

- EC2 creation uses `connection: local`
- Shutdown task uses `gather_facts`
- Ubuntu belongs to `Debian` OS family in Ansible facts
- Inventory is not required for EC2 provisioning playbook
- Inventory is required for remote management playbooks

---

# Author

**ZENITHRA aka Sonu Kumar Kushwaha**

Open for updates and improvements.

In case of any errors/issues, please connect via GitHub profile:

🔗 https://github.com/sonukkushwaha0801
