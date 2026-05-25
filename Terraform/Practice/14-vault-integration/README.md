# Project 15: Vault Integration - Complete Workflow

## Overview

This project demonstrates a **production-grade secret management workflow**:

1. **Deploy Vault Server** → EC2 instance with Vault installed
2. **Manually Add Secrets** → CLI-based secret creation
3. **Access Secrets in Terraform** → Terraform reads from Vault
4. **Deploy Infrastructure** → RDS database with Vault credentials
5. **Rotate Secrets** → Update without downtime

---

## Architecture

```
┌──────────────────────────────────────────┐
│           AWS Cloud                      │
├──────────────────────────────────────────┤
│                                          │
│  ┌────────────────────────────────────┐  │
│  │  EC2 Instance: Vault Server        │  │
│  │  ├─ 8200/tcp API                   │  │
│  │  └─ /var/lib/vault (data)          │  │
│  └────────────────────────────────────┘  │
│               ↓ SSH                       │
│  ┌────────────────────────────────────┐  │
│  │  Private Subnets                   │  │
│  │  ├─ RDS Database                   │  │
│  │  └─ Uses Vault credentials         │  │
│  └────────────────────────────────────┘  │
│                                          │
└──────────────────────────────────────────┘
         ↑
         │ Terraform reads secrets via API
         │
Your Local Machine (Terraform)
```

---

## File Structure

```
15-vault-integration/
├── vault-server.tf          # Vault server EC2 deployment
├── main.tf                  # RDS database that reads from Vault
├── provider.tf              # Terraform + AWS + Vault providers
├── variables.tf             # Input variables
├── outputs.tf               # Outputs for setup instructions
├── terraform.tfvars         # Configuration
├── README.md                # This file
└── steps.md                 # Detailed walkthrough
```

---

## Key Files Explained

### `vault-server.tf` (NEW)
Deploys EC2 instance with:
- Vault server installed via user data
- Automatic initialization (1 unseal key, root token)
- KV v2 secrets engine enabled
- Systemd service for Vault management

### `main.tf` (UPDATED)
- Reads secrets from Vault via `data.vault_generic_secret`
- Conditionally deploys RDS based on `enable_rds_database` flag
- Uses Vault credentials (username/password) for RDS

### `provider.tf` (UPDATED)
- AWS provider for EC2, RDS, networking
- Vault provider pointing to Vault server
- Both use variables for flexibility

---

## Three-Phase Deployment

### Phase 1: Deploy Vault Server
```bash
# Deploy only Vault infrastructure
terraform apply -target=aws_instance.vault_server \
                 -target=aws_key_pair.vault_key \
                 -target=aws_vpc.main

# Output: Vault server IP, SSH command
```

**Duration**: 2-3 minutes
**Manual step**: SSH in to get Root Token

### Phase 2: Add Secrets to Vault (MANUAL)
```bash
# SSH into Vault server
ssh -i vault-key ubuntu@<VAULT_IP>

# Manually add secrets
vault kv put secret/database/mysql \
  username="dbadmin" \
  password="SecurePassword123!"
```

**Duration**: 2-5 minutes
**Why manual**: Demonstrates understanding of Vault architecture

### Phase 3: Deploy RDS with Vault Secrets
```bash
# Enable RDS in terraform.tfvars
enable_rds_database = true

# Deploy RDS reading credentials from Vault
terraform apply
```

**Duration**: 5-10 minutes (RDS creation)
**Result**: RDS database created with credentials from Vault

---

## Workflow Comparison

### ❌ BAD (Hardcoded)
```hcl
resource "aws_db_instance" "main" {
  username = "admin"  # ❌ Visible in code
  password = "MyPassword123!"  # ❌ Visible in state
}
```
- Credentials in git history
- Team members see passwords
- Rotation requires code commit
- Audit trail: None

### ✅ GOOD (Vault)
```hcl
data "vault_generic_secret" "db" {
  path = "secret/database/mysql"  # ✅ Reference only
}

resource "aws_db_instance" "main" {
  username = data.vault_generic_secret.db.data.data.username
  password = data.vault_generic_secret.db.data.data.password
}
```
- Credentials in Vault (encrypted)
- Team accesses via Vault UI/API with permissions
- Rotation without code commit
- Full audit trail of access

---

## Interview Q&A

### Q: "Why not just use AWS Secrets Manager?"
**A**: Both work! Vault is:
- Provider-agnostic (works on-prem, multi-cloud)
- More features (dynamic secrets, PKI, policies)
- Widely used in enterprise
- Shows deeper infrastructure knowledge

### Q: "How do you rotate secrets without downtime?"
**A**:
1. Update secret in Vault
2. `terraform refresh` to detect change
3. `terraform apply` updates resource (some have minimal downtime)
4. For RDS: Can use read replicas for zero-downtime

### Q: "What if Vault server goes down?"
**A**:
- Resources still work (credentials already set)
- Can't deploy new resources until Vault recovers
- Solution: Vault HA with S3 backend + DynamoDB locking

### Q: "How do you handle multi-team Vault access?"
**A**:
- Vault policies restrict access per team
- Each team gets own Vault AppRole credentials
- Terraform uses team-specific AppRole
- Audit logs track who accessed what

---

## Setup Requirements

### Before Starting
- [ ] AWS account with credentials configured
- [ ] Terraform >= 1.0
- [ ] SSH key pair (will be generated)
- [ ] jq installed (for JSON parsing)
- [ ] MySQL client (optional, for testing connectivity)

### Estimated Costs
- EC2 t3.micro (Vault): ~$10/month
- RDS db.t3.micro: ~$30/month
- Total: ~$40/month
- **Lab cleanup**: Delete resources → $0/month

---

## Production Considerations

| Aspect | Dev Mode | Production |
|--------|----------|-----------|
| **TLS** | Disabled ❌ | Required ✅ |
| **Storage** | File-based | S3 + DynamoDB |
| **HA** | Single node | 3+ replicas |
| **Audit** | File logs | CloudWatch |
| **Backups** | Manual | Automated |
| **Access** | Root token | AppRole + policies |
| **Initialization** | Manual | Automated (Terraform) |

---

## Next Steps After Lab

1. **Enable TLS**: Use self-signed certs or AWS Certificate Manager
2. **Set up HA**: Deploy 3-node Vault cluster with S3 backend
3. **Implement Policies**: Create team-specific policies
4. **Dynamic Secrets**: Use Vault's dynamic database credentials
5. **PKI**: Manage TLS certificates with Vault
6. **Automation**: Add Vault setup to IaC pipeline

---

## Troubleshooting

### Problem: "terraform: not found" when applying
**Solution**: Vault provider not configured. Check provider.tf has vault block.

### Problem: "Connection refused" when reading secrets
**Solution**: Vault server not running. Check EC2 instance is running and healthy.

### Problem: "permission denied" when reading secret path
**Solution**: Vault token doesn't have permissions. Use root token initially, then add policies.

### Problem: RDS creation fails with "invalid password"
**Solution**: Check Vault secret format. Should be at `secret/data/database/mysql` not `secret/database/mysql`.

---

## Clean-Up Checklist

- [ ] `terraform destroy` to delete all resources
- [ ] Verify no resources in AWS Console
- [ ] Delete SSH keys: `rm vault-key*`
- [ ] Unset environment variables: `unset VAULT_ADDR VAULT_TOKEN`
- [ ] Check AWS billing for any remaining resources
