# 04-windows-ec2-connectivity-automation

## Task

Automate Windows EC2 connectivity from Kali Linux control node using Ansible and WinRM.

---

## Tasks Performed

1. Create Windows Server EC2 instance
2. Attach Elastic IP
3. Configure Security Group for:
   - RDP (3389)
   - WinRM HTTP (5985)
   - WinRM HTTPS (5986)

4. Connect to Windows EC2 using RDP from Kali Linux
5. Configure WinRM on Windows managed node
6. Enable PowerShell remoting
7. Configure Windows Firewall for WinRM
8. Validate WinRM listener availability
9. Configure production-style Ansible inventory
10. Configure group variables
11. Secure Windows credentials using Ansible Vault
12. Install required Ansible Windows collections
13. Install WinRM Python dependencies
14. Validate WinRM port connectivity from Kali Linux
15. Test Ansible connectivity using `win_ping`
16. Execute Windows connectivity validation playbook

---

## Expected Outcome

- Stable Kali Linux → Windows EC2 Ansible connectivity
- Secure authentication using Vault
- Functional WinRM-based Windows automation
- Production-style Ansible project structure
