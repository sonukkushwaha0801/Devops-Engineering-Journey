output "vault_server_public_ip" {
  description = "Vault server public IP address"
  value       = try(aws_instance.vault_server.public_ip, "")
}

output "vault_server_private_ip" {
  description = "Vault server private IP address"
  value       = try(aws_instance.vault_server.private_ip, "")
}

output "vault_address" {
  description = "Vault server address (use in Terraform provider)"
  value       = try("http://${aws_instance.vault_server.public_ip}:8200", "")
}

output "database_endpoint" {
  description = "RDS Database Endpoint (once created)"
  value       = try(aws_db_instance.main[0].endpoint, "")
  sensitive   = true
}

output "database_name" {
  description = "Database Name"
  value       = try(aws_db_instance.main[0].db_name, "vaultdemo")
}

output "vault_secret_path" {
  description = "Vault path containing database credentials"
  value       = "secret/database/mysql"
}

output "ssh_command" {
  description = "SSH command to access Vault server"
  value       = try("ssh -i vault-key ubuntu@${aws_instance.vault_server.public_ip}", "")
}

output "setup_instructions" {
  description = "Complete setup instructions"
  value = try(<<-EOT
╔════════════════════════════════════════════════════════════╗
║              VAULT INTEGRATION SETUP                       ║
╚════════════════════════════════════════════════════════════╝

1️⃣  VAULT SERVER DEPLOYED ✓
   IP:       ${aws_instance.vault_server.public_ip}
   Address:  http://${aws_instance.vault_server.public_ip}:8200

2️⃣  SSH INTO VAULT SERVER
   ssh -i vault-key ubuntu@${aws_instance.vault_server.public_ip}

3️⃣  GET INITIALIZATION DATA
   cat /root/vault-init.txt
   (Copy Root Token and Unseal Key)

4️⃣  MANUALLY ADD SECRETS TO VAULT
   export VAULT_ADDR="http://127.0.0.1:8200"
   export VAULT_TOKEN="<root-token>"

   vault kv put secret/database/mysql \
     username="dbadmin" \
     password="SecurePassword123!" \
     host="localhost" \
     port="3306"

5️⃣  CONFIGURE TERRAFORM
   export VAULT_ADDR="http://${aws_instance.vault_server.public_ip}:8200"
   export VAULT_TOKEN="<root-token>"

   Update terraform.tfvars:
   enable_rds_database = true

6️⃣  DEPLOY RDS
   terraform apply

See steps.md for detailed walkthrough!
EOT
  , "")
}
