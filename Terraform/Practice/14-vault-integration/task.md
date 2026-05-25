# Task: Terraform Vault Integration

# Objective

Master secret management by:
- Installing & configuring HashiCorp Vault locally
- Using Vault provider for Terraform
- Storing database credentials in Vault
- Dynamically generating database users
- Rotating secrets safely

---

# Infrastructure Goal

You will:
1. **Set up local Vault instance** (dev mode for learning)
2. **Store database credentials** in Vault
3. **Configure Terraform Vault provider**
4. **Create RDS database** with Vault-injected credentials
5. **Dynamically generate database users**
6. **Demonstrate secret rotation workflow**

---

# Concepts Covered

- Vault server setup & authentication
- Vault secrets engine
- Terraform Vault provider
- KV v2 secrets storage
- Vault policies
- Dynamic database credentials
- Secret rotation
- Security best practices

---

# AWS Services Used

| Service | Purpose |
|---------|---------|
| RDS     | Managed Database |

---

# External Services

| Service | Purpose |
|---------|---------|
| Vault   | Secret Management |

---

# Expected Result

After execution:
- Local Vault instance running with root credentials stored
- Database credentials stored and rotated in Vault
- Terraform reading secrets from Vault securely
- RDS database with dynamic user credentials
- Demonstrated secret lifecycle management

---

# Why This Matters (Interview Context)

**Production Scenario**: Your organization's secrets are hardcoded in git, environment variables scattered across servers, or stored in plain text config files. Leadership wants:
- Centralized secret management
- Automatic rotation
- Audit trails
- Zero-knowledge deployment

**Interview Question**: "How do you manage database passwords in production infrastructure?"

**Follow-ups**:
- "What happens when a developer leaves the company?"
- "How do you audit who accessed which secrets?"
- "Can you demonstrate secret rotation without downtime?"
