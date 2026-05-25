terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "training"
      Module      = "vault-integration"
      ManagedBy   = "terraform"
    }
  }
}

provider "vault" {
  address         = var.vault_addr
  skip_tls_verify = true # Only for dev/testing! Use proper certs in production
  token           = var.vault_token
}
