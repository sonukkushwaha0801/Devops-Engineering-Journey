# Vault Configuration
# WARNING: Never commit real tokens!
# Use environment variables instead:
# export TF_VAR_vault_addr="http://vault-server-ip:8200"
# export TF_VAR_vault_token="s.xxxxx"
# export TF_VAR_public_key="ssh-rsa AAAA..."

vault_addr          = "http://127.0.0.1:8200"
vault_token         = "root" # Replace with actual root token from Vault server
aws_region          = "us-east-1"
public_key          = ""    # REQUIRED: Add your SSH public key here
enable_vault_server = true  # Step 1: Deploy Vault server
enable_rds_database = false # Step 3: Enable after adding secrets to Vault
