# Windows EC2 Connectivity Automation using Ansible

This project automates and validates:

1. Windows EC2 provisioning readiness
2. WinRM configuration for Ansible
3. Secure Ansible connectivity from Kali Linux control node
4. Windows managed node authentication using Vault
5. Production-style inventory and variable management

---

# 🔹 Prerequisites

## 1. Control Node (Kali Linux)

Required:

- Python3
- Ansible
- WinRM Python libraries
- AWS `.pem` key

---

## Install Ansible

```bash
sudo apt update
sudo apt install ansible -y
```

---

## Install Windows Ansible Dependencies

```bash
pip install pywinrm requests-ntlm
```

---

## Install Required Collection

```bash
ansible-galaxy collection install ansible.windows
```

---

## Verify Installation

```bash
ansible --version
python3 --version
```

---

# 🔹 AWS EC2 Requirements

Create:

- 1 Windows Server EC2 instance
- Recommended AMI:
  - Windows Server 2022 Base

Recommended instance type:

```text
t3.micro
```

---

# 🔹 Security Group Requirements

Allow inbound traffic:

| Port | Protocol | Purpose |
|---|---|---|
| 3389 | TCP | RDP |
| 5985 | TCP | WinRM HTTP |
| 5986 | TCP | WinRM HTTPS |

> Restrict access to your public IP only.

---

# 🔹 Windows Managed Node Configuration

Inside Windows EC2 instance, open:

```text
PowerShell as Administrator
```

Run:

```powershell
winrm quickconfig -q
```

```powershell
Enable-PSRemoting -Force
```

```powershell
Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true
```

```powershell
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true
```

```powershell
Restart-Service WinRM
```

---

# 🔹 Verify WinRM Listener

```powershell
winrm enumerate winrm/config/listener
```

Expected:

```text
Transport = HTTP
Port = 5985
```

---

# 🔹 Project Structure

```text
04-windows-ec2-connectivity-automation/
├── files/
├── inventories/
│   └── prod/
│       ├── group_vars/
│       │   └── windows.yml
│       └── hosts.ini
├── playbooks/
│   └── win-connectivity-check.yml
├── roles/
├── templates/
├── vars/
│   └── windows-secrets.yml
├── README.md
├── TASK.md
└── .gitignore
```

---

# 🔹 Inventory Configuration

Update:

```text
inventories/prod/hosts.ini
```

Example:

```ini
[windows]
ansible-win-node-1 ansible_host=<WINDOWS_PUBLIC_IP>

[windows:vars]
ansible_connection=winrm
ansible_winrm_transport=ntlm
ansible_winrm_server_cert_validation=ignore
ansible_port=5985
```

---

# 🔹 Group Variables

File:

```text
inventories/prod/group_vars/windows.yml
```

Content:

```yaml
---
ansible_user: Administrator
ansible_connection: winrm
ansible_winrm_transport: ntlm
ansible_winrm_server_cert_validation: ignore
ansible_port: 5985
ansible_winrm_scheme: http
```

---

# 🔹 Vault Setup

Create encrypted vault:

```bash
ansible-vault create vars/windows-secrets.yml
```

Example:

```yaml
---
ansible_password: 'WINDOWS_PASSWORD'
```

---

# 🔹 Connectivity Validation

## Test WinRM Port

```bash
nc -zv <WINDOWS_PUBLIC_IP> 5985
```

Expected:

```text
succeeded
```

---

## Test Ansible Connectivity

```bash
ansible windows \
-i inventories/prod/hosts.ini \
-m ansible.windows.win_ping \
-e "@vars/windows-secrets.yml" \
--ask-vault-pass
```

Expected:

```text
pong
```

---

# 🔹 Run Playbook

```bash
ansible-playbook \
-i inventories/prod/hosts.ini \
playbooks/win-connectivity-check.yml \
--ask-vault-pass
```

Expected:

```text
ok=1
failed=0
```

---

# 🔹 Notes

- Vault used for secure credential handling
- WinRM connectivity validated from Kali Linux
- Inventory organized using production-style structure
- Windows authentication handled using NTLM
- Project focused on troubleshooting real-world Windows automation issues

---

# ⚠️ Important

Do NOT push:

```text
vars/windows-secrets.yml
```

to GitHub.

Either:

- delete it before push
- or replace with dummy credentials

---

# 👤 Author

**ZENITHRA aka Sonu Kumar Kushwaha**

GitHub:
🔗 https://github.com/sonukkushwaha0801
