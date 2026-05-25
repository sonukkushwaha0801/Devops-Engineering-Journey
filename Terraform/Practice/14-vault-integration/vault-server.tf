# ==========================================
# PART 1: Deploy Vault Server on EC2
# ==========================================

# Security Group for Vault Server
resource "aws_security_group" "vault_sg" {
  name        = "vault-server-sg"
  description = "Security group for Vault server"
  vpc_id      = aws_vpc.main.id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ RESTRICT IN PRODUCTION
  }

  # Vault API access
  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ RESTRICT IN PRODUCTION
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vault-server-sg"
  }
}

# EC2 Key Pair for SSH
resource "aws_key_pair" "vault_key" {
  key_name   = "vault-server-key"
  public_key = var.public_key # Provide your SSH public key

  tags = {
    Name = "vault-server-key"
  }
}

# User Data Script - Install and Start Vault
locals {
  vault_install_script = base64encode(<<-EOF
#!/bin/bash
set -e

# Update system
apt-get update
apt-get install -y curl unzip wget

# Install Vault
VAULT_VERSION="1.15.0"
cd /tmp
wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
unzip vault_${VAULT_VERSION}_linux_amd64.zip
sudo mv vault /usr/local/bin/
sudo chmod +x /usr/local/bin/vault

# Create vault user
useradd --system --home /etc/vault --shell /bin/false vault 2>/dev/null || true

# Create directories
mkdir -p /etc/vault
mkdir -p /var/log/vault
chown vault:vault /etc/vault
chown vault:vault /var/log/vault

# Create Vault config file
cat > /etc/vault/vault.hcl <<'VAULT_CONFIG'
api_addr = "http://0.0.0.0:8200"
ui = true

storage "file" {
  path = "/var/lib/vault"
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_disable   = "true"  # ⚠️ ONLY FOR DEV! Use TLS in production
}
VAULT_CONFIG

mkdir -p /var/lib/vault
chown vault:vault /var/lib/vault

# Create systemd service
cat > /etc/systemd/system/vault.service <<'VAULT_SERVICE'
[Unit]
Description=HashiCorp Vault
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
ProtectSystem=full
ProtectHome=yes
NoNewPrivileges=yes
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
LimitNOFILE=65536
LimitNPROC=512
KillMode=process
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
LimitMEMLOCK=infinity
ExecStart=/usr/local/bin/vault server -config=/etc/vault/vault.hcl
ExecReload=/bin/kill -HUP $MAINPID
User=vault
Group=vault
StandardOutput=journal
StandardError=journal
SyslogIdentifier=vault

[Install]
WantedBy=multi-user.target
VAULT_SERVICE

systemctl daemon-reload
systemctl enable vault
systemctl start vault

# Wait for Vault to be ready
sleep 5

# Initialize Vault and save keys
export VAULT_ADDR="http://127.0.0.1:8200"

# Check if already initialized
if ! vault status 2>/dev/null | grep -q "Initialized"; then
  vault operator init -key-shares=1 -key-threshold=1 > /root/vault-init.txt 2>&1

  # Extract unseal key and root token
  UNSEAL_KEY=$(grep "Unseal Key" /root/vault-init.txt | awk '{print $NF}')
  ROOT_TOKEN=$(grep "Root Token" /root/vault-init.txt | awk '{print $NF}')

  # Unseal Vault
  vault operator unseal "$UNSEAL_KEY" > /dev/null 2>&1

  # Login
  vault login "$ROOT_TOKEN" > /dev/null 2>&1

  # Enable KV v2 secrets engine
  vault secrets enable -version=2 -path=secret kv > /dev/null 2>&1
fi

echo "Vault is ready!"
vault status
  EOF
  )
}

# EC2 Instance - Vault Server
resource "aws_instance" "vault_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.vault_sg.id]
  subnet_id              = aws_subnet.public_1.id
  key_name               = aws_key_pair.vault_key.key_name
  user_data              = local.vault_install_script

  associate_public_ip_address = true

  tags = {
    Name = "vault-server"
  }

  depends_on = [
    aws_internet_gateway.main,
    aws_route_table_association.public_1
  ]
}

# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Public Subnet for Vault Server
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "vault-public-1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vault-igw"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "vault-public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# ==========================================
# PART 2: Access Vault from Terraform
# ==========================================

# Wait for Vault to be ready and get initialization details
resource "null_resource" "wait_for_vault" {
  provisioner "local-exec" {
    command = "sleep 15" # Wait for Vault to start
  }

  depends_on = [aws_instance.vault_server]
}

# Output Vault Server Details
output "vault_server_public_ip" {
  description = "Vault server public IP"
  value       = aws_instance.vault_server.public_ip
}

output "vault_server_private_ip" {
  description = "Vault server private IP"
  value       = aws_instance.vault_server.private_ip
}

output "vault_address" {
  description = "Vault server address (use this in terraform)"
  value       = "http://${aws_instance.vault_server.public_ip}:8200"
}

output "next_steps" {
  description = "Next steps to configure secrets"
  value       = <<-EOT
1. SSH into Vault server:
   ssh -i your-private-key ubuntu@${aws_instance.vault_server.public_ip}

2. Check Vault initialization file:
   cat /root/vault-init.txt

3. Copy the Root Token and Unseal Key

4. Configure Terraform:
   export VAULT_ADDR="http://${aws_instance.vault_server.public_ip}:8200"
   export VAULT_TOKEN="<root-token-from-step-2>"

5. Add secrets manually (see steps.md)

6. Apply Terraform to read secrets from RDS
  EOT
}
