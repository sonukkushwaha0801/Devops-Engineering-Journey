# Vault Integration - Complete Hands-On Lab

## Architecture

```
Step 1: Create Vault Server (EC2)
        ↓
Step 2: SSH into Vault & Manually Add Secrets (KV v2)
        ↓
Step 3: Configure Terraform Vault Provider
        ↓
Step 4: Deploy RDS Reading from Vault
```

---

# STEP 1: Generate SSH Key Pair

```bash
cd /path/to/Practice/15-vault-integration

# Generate SSH key (if you don't have one)
ssh-keygen -t rsa -b 4096 -f vault-key -N ""

# Display public key (copy this)
cat vault-key.pub
```

Output:
```
ssh-rsa AAAA...your-long-key...AAAA user@machine
```

---

# STEP 2: Update terraform.tfvars with Your Public Key

```bash
# Edit terraform.tfvars
cat > terraform.tfvars << 'EOF'
vault_addr                = "http://127.0.0.1:8200"
vault_token               = "root"
aws_region                = "us-east-1"
public_key                = "ssh-rsa AAAA...your-key-from-above...AAAA"
enable_vault_server       = true
enable_rds_database       = false
EOF
```

---

# STEP 3: Verify AWS Credentials

```bash
aws sts get-caller-identity
```

Expected output:
```json
{
    "UserId": "AIDAI...",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/your-user"
}
```

---

# STEP 4: Initialize Terraform & Deploy Vault Server

```bash
# Initialize Terraform
terraform init

# Plan the deployment (Vault server only)
terraform plan -var-file=terraform.tfvars \
  -target=aws_instance.vault_server \
  -target=aws_key_pair.vault_key \
  -target=aws_vpc.main \
  -target=aws_internet_gateway.main

# Apply - Deploy Vault Server EC2 Instance
terraform apply \
  -target=aws_instance.vault_server \
  -target=aws_key_pair.vault_key \
  -target=aws_vpc.main \
  -target=aws_internet_gateway.main \
  -target=aws_security_group.vault_sg \
  -target=aws_subnet.public_1 \
  -target=aws_route_table.public \
  -target=aws_route_table_association.public_1

# Get Vault server IP
VAULT_IP=$(terraform output -raw vault_server_public_ip)
echo "Vault Server IP: $VAULT_IP"
```

Expected output:
```
Apply complete! Resources created in order of application.

Outputs:

vault_address = "http://54.123.45.67:8200"
vault_server_public_ip = "54.123.45.67"
```

---

# STEP 5: Wait for Vault Server to Start (2-3 minutes)

```bash
# Monitor Vault server startup
watch -n 5 "curl -s http://$VAULT_IP:8200/v1/sys/health | jq ."

# When you see JSON response, Vault is running. Press Ctrl+C
```

Expected (when ready):
```json
{
  "initialized": true,
  "sealed": false,
  "standby": false,
  "performance_standby": false,
  "replication_performance_mode": "",
  "replication_dr_mode": "",
  "server_time_utc": 1234567890,
  "version": "1.15.0"
}
```

---

# STEP 6: SSH into Vault Server & Retrieve Credentials

```bash
# SSH into Vault server
ssh -i vault-key ubuntu@$VAULT_IP

# Inside the Vault server, check initialization file
cat /root/vault-init.txt

# Output will show:
# ===== Vault Initialization Output =====
# Unseal Key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# Initial Root Token: s.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**COPY THESE TWO VALUES** - you'll need them!

---

# STEP 7: Manually Add Secrets to Vault (Inside Server)

```bash
# Still inside the server (ssh session), set environment variables
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="s.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"  # Use the Root Token from step 6

# Verify Vault is accessible
vault status

# Expected:
# Key             Value
# ---             -----
# Seal Type       shamir
# Initialized     true
# Sealed          false
# Total Shares    1
# Threshold       1
# Version         1.15.0

# Check if KV v2 secrets engine is enabled
vault secrets list

# It should show: secret/   kv   version=2

# Now add database credentials to Vault
vault kv put secret/database/mysql \
  username="dbadmin" \
  password="VaultSecurePassword123!" \
  host="localhost" \
  port="3306" \
  engine="mysql"

# Verify the secret was stored
vault kv get secret/database/mysql

# Expected output:
# ===== Secret Path =====
# secret/data/database/mysql
#
# ===== Data =====
# Key       Value
# ---       -----
# engine    mysql
# host      localhost
# password  VaultSecurePassword123!
# port      3306
# username  dbadmin
```

✅ **Secrets now stored in Vault!**

```bash
# Exit SSH session
exit
```

---

# STEP 8: Configure Terraform to Access Vault

Back on your local machine:

```bash
# Set environment variables with Vault details
export VAULT_ADDR="http://$VAULT_IP:8200"
export VAULT_TOKEN="s.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"  # Root token from step 6

# Verify Terraform can access Vault
vault kv get secret/database/mysql

# Expected:
# ===== Secret Path =====
# secret/data/database/mysql
# Key       Value
# host      localhost
# password  VaultSecurePassword123!
# username  dbadmin
```

---

# STEP 9: Plan RDS Deployment (Reads from Vault)

```bash
# Update terraform.tfvars to enable RDS
cat > terraform.tfvars << 'EOF'
vault_addr                = "http://$VAULT_IP:8200"
vault_token               = "s.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
aws_region                = "us-east-1"
public_key                = "ssh-rsa AAAA...your-key..."
enable_vault_server       = true
enable_rds_database       = true  # NOW ENABLED
EOF

# Verify Terraform reads secrets from Vault
terraform plan

# Check the plan - should show:
# - RDS database will be created
# - Username/password from Vault (shown as ***)
# - Database name: vaultdemo
```

---

# STEP 10: Deploy RDS Database

```bash
# Apply to create RDS instance
terraform apply

# This will:
# 1. Read secrets from Vault
# 2. Create RDS database with those credentials
# 3. Output database endpoint

# Get outputs
terraform output

# Expected:
# database_endpoint = "vault-demo-db.xxxxx.rds.amazonaws.com:3306"
# database_name = "vaultdemo"
# vault_secret_path = "secret/database/mysql"
```

RDS creation takes 5-10 minutes...

---

# STEP 11: Verify Terraform Read Secrets Successfully

```bash
# Check Terraform state (secrets marked as sensitive)
terraform state show aws_db_instance.main[0] | grep username

# Should show username from Vault (no plaintext password shown)

# Verify in AWS Console
aws rds describe-db-instances \
  --db-instance-identifier vault-demo-db \
  --query 'DBInstances[0].{DBName:DBName,MasterUsername:MasterUserAccount}'
```

---

# STEP 12: Test Database Connectivity

```bash
# Get database endpoint
DB_ENDPOINT=$(terraform output -raw database_endpoint)

# Try to connect (from local machine if security groups allow)
# Note: RDS is in private subnet, so you need a bastion or port forwarding

# OR connect through SSH tunnel:
ssh -i vault-key -L 3306:$DB_ENDPOINT ubuntu@$VAULT_IP &

# Then from another terminal:
mysql -h 127.0.0.1 -u dbadmin -p'VaultSecurePassword123!' -e "SELECT 1;"

# Expected: Returns 1 (connection successful)
```

---

# STEP 13: Verify Audit Trail

Vault logs all secret access. Check it:

```bash
# SSH back into Vault server
ssh -i vault-key ubuntu@$VAULT_IP

# Set environment again
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="s.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# View audit logs
vault audit list

# List recent authentications
vault audit enable file file_path=/var/log/vault/audit.log 2>/dev/null || true

# View logs
tail -f /var/log/vault/audit.log
```

---

# STEP 14: Rotate Secrets

```bash
# Back on local machine, update secret in Vault
export VAULT_ADDR="http://$VAULT_IP:8200"
export VAULT_TOKEN="s.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Update the secret
vault kv put secret/database/mysql \
  username="dbadmin" \
  password="NewSecurePassword456!" \
  host="localhost" \
  port="3306" \
  engine="mysql"

# Re-run Terraform to update RDS
terraform refresh

terraform plan
# Should detect password change

terraform apply
# Updates RDS with new password
```

---

# STEP 15: Clean Up

```bash
# Destroy RDS first (safest order)
terraform destroy -target='aws_db_instance.main'

# Destroy Vault server and infrastructure
terraform destroy

# Delete SSH key
rm vault-key vault-key.pub

# Confirm
aws ec2 describe-instances --filters "Name=tag:Name,Values=vault-server" --query 'Reservations[].Instances[].State.Name'
# Should be empty or show "terminated"
```

---

# Key Learnings

| Concept | Interview Win |
|---------|---------------|
| Manual secret creation | Shows understanding of secret lifecycle |
| SSH + Port forwarding | Network security knowledge |
| Vault audit logs | Compliance & security |
| Secret rotation | Production-grade operations |
| Terraform + Vault integration | Infrastructure-as-code best practice |

---

# Interview Follow-Up Questions

1. "How do you rotate secrets without downtime?"
2. "What happens if Vault server goes down?"
3. "How do you audit secret access?"
4. "Can you rotate Vault tokens automatically?"
5. "How would you secure this in production (TLS, HA)?"

---

# Production Checklist

- [ ] Enable TLS for Vault API
- [ ] Set up Vault HA with S3 backend
- [ ] Enable audit logging
- [ ] Configure secret rotation policies
- [ ] Restrict network access (security groups)
- [ ] Set up Vault backup procedure
- [ ] Document secret management process
- [ ] Train team on secret access
