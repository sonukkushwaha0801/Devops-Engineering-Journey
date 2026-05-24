# Terraform Resources

# What is a Resource?

A Resource is the fundamental infrastructure object managed by Terraform.

Examples:
- EC2 Instance
- S3 Bucket
- Azure VM
- GCP Compute Engine
- Security Group
- VPC
- Load Balancer

Terraform uses resources to:
- create
- update
- delete
- manage infrastructure lifecycle

---

# Resource Syntax

Basic Syntax:
```hcl
resource "<PROVIDER>_<RESOURCE_TYPE>" "<LOCAL_NAME>" {

}
```

Example:
```hcl
resource "aws_instance" "web" {

}
```

Components:

| Component      | Meaning                  |
| -------------- | ------------------------ |
| `resource`     | Terraform resource block |
| `aws_instance` | Resource type            |
| `web`          | Local resource name      |

---

# Resource Naming Convention

Production Naming:
```hcl
resource "aws_instance" "frontend_web" {}
```

Avoid:
```hcl
resource "aws_instance" "test" {}
```

Reason:
- readability
- maintainability
- scalable infrastructure

---

# AWS EC2 Instance Resource

## Basic EC2 Creation

```hcl
resource "aws_instance" "frontend_web" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"

  tags = {
    Name        = "frontend-web"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

---

# Important EC2 Arguments

| Argument                 | Purpose                  |
| ------------------------ | ------------------------ |
| `ami`                    | Machine image            |
| `instance_type`          | VM size                  |
| `subnet_id`              | Target subnet            |
| `vpc_security_group_ids` | Attached security groups |
| `key_name`               | SSH key                  |
| `user_data`              | Bootstrap script         |

---

# Production EC2 Example

```hcl
resource "aws_instance" "frontend_web" {
  ami                    = "ami-0f5ee92e2d63afc18"
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = "prod-key"

  user_data = file("scripts/bootstrap.sh")

  tags = {
    Name        = "frontend-web"
    Environment = "prod"
    Owner       = "platform-team"
    ManagedBy   = "terraform"
  }
}
```

Production Notes:
- Avoid hardcoded AMIs
- Use launch templates later
- Use user_data carefully
- Use proper tagging standards

---

# AWS S3 Bucket Resource

## Basic S3 Bucket

```hcl
resource "aws_s3_bucket" "app_logs" {
  bucket = "prod-app-logs-bucket"
}
```

---

# Production S3 Bucket Example

```hcl
resource "aws_s3_bucket" "app_logs" {
  bucket = "prod-app-logs-bucket"

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

Enable Versioning:
```hcl
resource "aws_s3_bucket_versioning" "app_logs_versioning" {
  bucket = aws_s3_bucket.app_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

Production Notes:
- Always enable versioning
- Block public access
- Enable encryption
- Use lifecycle policies

---

# Azure Resources

# Azure Resource Group

```hcl
resource "azurerm_resource_group" "platform_rg" {
  name     = "platform-rg"
  location = "Central India"
}
```

---

# Azure Virtual Machine

```hcl
resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                = "frontend-vm"
  resource_group_name = azurerm_resource_group.platform_rg.name
  location            = azurerm_resource_group.platform_rg.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.frontend_nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

Production Notes:
- Use managed identities
- Use premium disks for production
- Avoid password authentication

---

# Azure Storage Account

```hcl
resource "azurerm_storage_account" "app_storage" {
  name                     = "prodappstorage001"
  resource_group_name      = azurerm_resource_group.platform_rg.name
  location                 = azurerm_resource_group.platform_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "prod"
  }
}
```

Production Notes:
- Enable private endpoints
- Restrict public access
- Enable diagnostics logging

---

# GCP Resources

# GCP Compute Engine VM

```hcl
resource "google_compute_instance" "frontend_vm" {
  name         = "frontend-vm"
  machine_type = "e2-medium"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {

    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  tags = ["frontend", "terraform"]
}
```

Production Notes:
- Avoid default VPC usage
- Use service accounts
- Restrict public IP exposure

---

# GCP Storage Bucket

```hcl
resource "google_storage_bucket" "app_logs" {
  name     = "prod-app-logs-bucket"
  location = "ASIA-SOUTH1"

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}
```

Production Notes:
- Enable versioning
- Enable retention policies
- Use IAM-based access

---

# Resource Arguments

Arguments configure resource behavior.

Example:
```hcl
instance_type = "t2.micro"
```

Types:
- Required
- Optional
- Computed

---

# Resource Attributes

Attributes are generated after resource creation.

Example:
```hcl
aws_instance.web.public_ip
```

Used for:
- outputs
- dependencies
- inter-resource communication

---

# Referencing Resources

Syntax:
```hcl
<RESOURCE_TYPE>.<LOCAL_NAME>.<ATTRIBUTE>
```

Example:
```hcl
aws_instance.frontend_web.public_ip
```

---

# Implicit Dependencies

Terraform automatically detects dependencies.

Example:
```hcl
resource "aws_instance" "web" {
  subnet_id = aws_subnet.public.id
}
```

Terraform understands:
```text
EC2 depends on subnet
```

---

# Explicit Dependencies

Use:
```hcl
depends_on
```

Example:
```hcl
depends_on = [aws_security_group.web]
```

Production Recommendation:
Use only when implicit dependency is insufficient.

---

# Resource Lifecycle

Terraform manages:
- Create
- Read
- Update
- Delete

Known as:
```text
CRUD Operations
```

---

# Resource Lifecycle Rules

Example:
```hcl
lifecycle {
  create_before_destroy = true
}
```

Useful For:
- zero downtime deployments
- load balancers
- ASG replacements

---

# Common Lifecycle Arguments

| Argument                | Purpose                       |
| ----------------------- | ----------------------------- |
| `create_before_destroy` | Prevent downtime              |
| `prevent_destroy`       | Protect critical infra        |
| `ignore_changes`        | Ignore external modifications |

---

# Example: prevent_destroy

```hcl
resource "aws_db_instance" "prod_db" {

  lifecycle {
    prevent_destroy = true
  }
}
```

Production Use:
Protect:
- databases
- production storage
- critical infrastructure

---

# Resource Meta Arguments

| Meta Argument | Purpose             |
| ------------- | ------------------- |
| `depends_on`  | Explicit dependency |
| `count`       | Multiple resources  |
| `for_each`    | Iterative resources |
| `provider`    | Provider selection  |
| `lifecycle`   | Lifecycle behavior  |

---

# count Example

```hcl
resource "aws_instance" "web" {
  count = 3

  ami           = "ami-xxxx"
  instance_type = "t2.micro"
}
```

Creates:
```text
3 EC2 instances
```

---

# for_each Example

```hcl
resource "aws_s3_bucket" "env_buckets" {
  for_each = toset(["dev", "staging", "prod"])

  bucket = "${each.key}-logs-bucket"
}
```

Production Advantage:
Better state stability than `count`.

---

# Resource Drift

Drift occurs when infrastructure changes outside Terraform.

Example:
- manual console changes
- deleted resources
- modified security groups

Impact:
Terraform state becomes inaccurate.

Production Solution:
- restrict manual access
- run drift detection pipelines
- use governance policies

---

# Common Enterprise Mistakes

| Mistake                  | Impact           |
| ------------------------ | ---------------- |
| Hardcoded values         | Poor scalability |
| No tagging               | Poor governance  |
| Manual infra changes     | Drift            |
| Large monolithic files   | Hard maintenance |
| Using default VPC        | Security issues  |
| Publicly exposed storage | Data leaks       |

---

# Production Best Practices

## Use Tags Everywhere

Mandatory Tags:
```text
Environment
Application
Owner
ManagedBy
CostCenter
```

---

## Avoid Hardcoded AMIs

Use:
- data sources
- image pipelines
- golden AMIs

---

## Separate Networking Layer

Do NOT mix:
- networking
- compute
- storage

inside giant files.

---

## Use Modular Resource Design

Separate:
- VPC
- compute
- storage
- IAM
- security

into reusable modules.

---

## Protect Critical Resources

Use:
```hcl
prevent_destroy = true
```

for:
- databases
- production buckets
- state storage

---

# Interview Questions

## What is a Terraform Resource?

A resource is an infrastructure object managed by Terraform.

---

## Difference between Resource and Provider

| Component | Purpose               |
| --------- | --------------------- |
| Provider  | API integration       |
| Resource  | Infrastructure object |

---

## What is Resource Drift?

When actual infrastructure differs from Terraform state/configuration.

Usually caused by:
- manual changes
- external automation
- unmanaged updates

---

## Why use `for_each` over `count`?

Advantages:
- stable resource indexing
- safer modifications
- better scalability

---

## What does `create_before_destroy` solve?

Prevents downtime during infrastructure replacement operations.

---

# Production Reality

In enterprise environments resource management becomes difficult because:
- infrastructure scales rapidly
- teams modify infrastructure frequently
- multiple environments exist
- cloud APIs evolve constantly

Production Terraform engineering focuses heavily on:
- modularity
- lifecycle protection
- drift prevention
- tagging governance
- safe replacement strategies
- scalable resource organization
