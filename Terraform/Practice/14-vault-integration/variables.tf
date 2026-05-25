variable "vault_addr" {
  description = "HashiCorp Vault server address"
  type        = string
  sensitive   = true
  # Will be auto-populated from Vault server output
  default = "http://127.0.0.1:8200"
}

variable "vault_token" {
  description = "HashiCorp Vault authentication token"
  type        = string
  sensitive   = true
  # Get from: aws_instance.vault_server outputs (see steps.md)
  default = "root" # Will be replaced with actual root token
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "public_key" {
  description = "SSH public key for Vault server access"
  type        = string
  # Generate with: ssh-keygen -t rsa -b 4096 -f vault-key
  # Then: cat vault-key.pub
}

variable "enable_vault_server" {
  description = "Enable Vault server deployment"
  type        = bool
  default     = true
}

variable "enable_rds_database" {
  description = "Enable RDS database deployment (requires Vault secrets)"
  type        = bool
  default     = false # Set to true after adding secrets to Vault
}
