# Ansible Task Execution — Setup & Prerequisites

This project automates the following:

1. Ensure `openssh` and `openssl` are **latest version** (only if already installed)
2. Check whether **Docker is installed**
3. Install Docker **only if not present**

---

## 🔹 Prerequisites

### 1. Control Node (Your Machine)

- Python 3 installed
- Ansible installed
- SSH client available

#### Install Ansible

```bash
sudo apt update
sudo apt install ansible -y
```

#### Verify

```bash
ansible --version
python3 --version
```

---

### 2. Inventory Setup

Create `inventory.ini`:

```ini
[all]
node1 ansible_host=<IP_1> ansible_user=ubuntu
node2 ansible_host=<IP_2> ansible_user=ubuntu

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

---

### 3. SSH Key Setup (Passwordless Access)

Copy your SSH key to remote servers:

```bash
ssh-copy-id -o "IdentityFile <.pem>" ubuntu@<IPv4>
```

> Example:

```bash
ssh-copy-id -o "IdentityFile my-key.pem" ubuntu@13.206.xxx.xxx
```

---

### 4. Test SSH Access

```bash
ssh ubuntu@<IP>
```

---

### 5. Test Ansible Connectivity

```bash
ansible all -i inventory.ini -m ping
```

Expected:

```
SUCCESS
```

---

### 6. Managed Nodes Requirements (EC2)

Each target node must have:

- Python3 installed
- Sudo access enabled
- APT working
- Internet access (for package installation)

---

### 7. Privilege Escalation

Ensure playbook includes:

```yaml
become: true
```

---

### 8. Network Requirements

Allow outbound:

- HTTPS (port 443)

---

### 9. Vault (Optional)

If using encrypted variables:

```bash
ansible-playbook -i inventory.ini execution-of-task.yaml --vault-password-file vault.pass
```

---

## 🔹 Project Structure

⚠️ **WARNING BEFORE RUNNING**

You are only provided with:

- `inventory.ini`
- `execution-of-task.yaml`
- Task description file (text)

All other required files must be **manually placed in the correct location** before execution.

Missing configuration will cause:

- `.pem` key → SSH connection failure
- AWS credentials → EC2 provisioning failure
- Incorrect inventory configuration → remote task execution failure

Update the `hosts-prod.ini` file with your managed node details.

> Important: Before running the playbook, manually connect to all managed nodes at least once via SSH and verify access using the `.pem` key.

### Expected Structure

```
.
├── inventory.ini
├── execution-of-task.yaml
├── task.txt
├── my-key.pem          # REQUIRED (add manually)
└── vault.pass          # OPTIONAL (if using vault)
```

---

## 🔹 Notes

- Tasks are **idempotent**
- Docker installation is **conditional**
- Package upgrades apply **only if already installed**

---

# Command for Running Ansible Playbook:

```
ansible-playbook -i inventory.ini execution-of-task.yaml
```

---

## 👤 Author

**ZENITHRA aka Sonu Kumar Kushwaha**

Open for updates and improvements.
In case of any errors or issues, please reach out via LinkedIn profile (link available in GitHub):
🔗 https://github.com/sonukkushwaha0801
