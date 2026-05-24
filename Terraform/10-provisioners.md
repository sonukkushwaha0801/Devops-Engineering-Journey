# Terraform Provisioners

# What are Provisioners?

Provisioners execute scripts or commands:
- locally
- remotely

during resource lifecycle operations.

Used for:
- bootstrapping
- configuration
- automation
- temporary operational tasks

---

# Important Production Reality

Provisioners are considered:
```text
Last Resort
```

HashiCorp Recommendation:
Prefer:
- cloud-init
- Ansible
- Packer
- Kubernetes
- configuration management tools

over provisioners whenever possible.

---

# Why Provisioners are Risky

Problems:
- non-idempotent behavior
- hard debugging
- state inconsistency
- SSH dependency
- unreliable execution

Production Impact:
Provisioners can create:
- partially configured infrastructure
- deployment instability
- difficult recovery scenarios

---

# Types of Provisioners

| Provisioner   | Purpose                    |
| ------------- | -------------------------- |
| `local-exec`  | Executes locally           |
| `remote-exec` | Executes on remote machine |
| `file`        | Transfers files            |

---

# local-exec Provisioner

Executes commands on:
```text
Local machine running Terraform
```

---

# local-exec Example

```hcl
resource "aws_instance" "frontend" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ips.txt"
  }
}
```

Behavior:
Writes EC2 public IP locally.

---

# local-exec Use Cases

Good For:
- logging
- notifications
- inventory generation
- triggering external automation

Bad For:
- infrastructure configuration
- application deployment

---

# local-exec Environment Variables

Example:
```hcl
provisioner "local-exec" {
  command = "echo Instance Created"

  environment = {
    ENVIRONMENT = "prod"
  }
}
```

---

# remote-exec Provisioner

Executes commands directly on remote resource.

Requires:
- SSH access
- network connectivity
- credentials

---

# remote-exec Example

```hcl
resource "aws_instance" "frontend" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  key_name      = "prod-key"

  provisioner "remote-exec" {

    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
```

---

# remote-exec Execution Types

| Method    | Purpose                  |
| --------- | ------------------------ |
| `inline`  | List of commands         |
| `script`  | Execute local script     |
| `scripts` | Execute multiple scripts |

---

# Script Execution Example

```hcl
provisioner "remote-exec" {
  script = "scripts/bootstrap.sh"
}
```

---

# File Provisioner

Used to transfer files to remote resources.

---

# File Provisioner Example

```hcl
resource "aws_instance" "frontend" {

  provisioner "file" {
    source      = "nginx.conf"
    destination = "/tmp/nginx.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
```

---

# Combined Provisioner Workflow

Example:
```text
file       → copy config
remote-exec → apply config
```

---

# Example: File + remote-exec

```hcl
resource "aws_instance" "frontend" {

  provisioner "file" {
    source      = "app.conf"
    destination = "/tmp/app.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {

    inline = [
      "sudo mv /tmp/app.conf /etc/nginx/nginx.conf",
      "sudo systemctl restart nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
```

---

# Connection Block

Provisioners requiring remote access use:
```hcl
connection {}
```

---

# SSH Connection Example

```hcl
connection {
  type        = "ssh"
  user        = "ubuntu"
  private_key = file("~/.ssh/id_rsa")
  host        = self.public_ip
}
```

---

# WinRM Connection Example

```hcl
connection {
  type     = "winrm"
  user     = "Administrator"
  password = var.admin_password
  host     = self.public_ip
}
```

---

# Provisioner Execution Timing

Default:
```text
After resource creation
```

---

# Destroy-Time Provisioners

Executed during:
```text
terraform destroy
```

Example:
```hcl
provisioner "local-exec" {
  when    = destroy
  command = "echo Resource Destroyed"
}
```

---

# on_failure Behavior

Default:
```text
Terraform fails
```

---

# Continue on Failure

Example:
```hcl
provisioner "remote-exec" {
  on_failure = continue
}
```

Production Warning:
Can leave infrastructure partially configured.

---

# self Object

Provisioners use:
```hcl
self
```

Example:
```hcl
self.public_ip
```

Purpose:
Access current resource attributes.

---

# Null Resource

Used to run provisioners without infrastructure resources.

---

# null_resource Example

```hcl
resource "null_resource" "deploy" {

  provisioner "local-exec" {
    command = "echo Deployment Started"
  }
}
```

---

# Trigger-Based Execution

Example:
```hcl
resource "null_resource" "deploy" {

  triggers = {
    build_version = timestamp()
  }

  provisioner "local-exec" {
    command = "deploy.sh"
  }
}
```

Production Usage:
- deployment hooks
- CI/CD integration
- automation triggers

---

# Provisioners vs User Data

Preferred:
```text
User Data / cloud-init
```

Instead of:
```text
remote-exec
```

Reason:
- idempotent
- scalable
- cloud-native
- faster bootstrapping

---

# Better Alternative Example

```hcl
resource "aws_instance" "frontend" {

  user_data = file("scripts/bootstrap.sh")
}
```

Production Recommendation:
Prefer:
- user_data
- cloud-init
- Ansible

over provisioners.

---

# Provisioners and Terraform State

Provisioner actions are:
```text
NOT tracked in state
```

Meaning:
Terraform cannot fully validate:
- script results
- configuration drift
- partial execution

---

# Common Enterprise Mistakes

| Mistake                                         | Impact                 |
| ----------------------------------------------- | ---------------------- |
| Heavy remote-exec usage                         | Unstable infra         |
| Application deployment via Terraform            | Poor separation        |
| Hardcoded SSH keys                              | Security risk          |
| Non-idempotent scripts                          | Drift                  |
| Using provisioners for configuration management | Operational complexity |

---

# Production Best Practices

## Avoid Provisioners When Possible

Prefer:
- Packer
- Ansible
- cloud-init
- Kubernetes
- CI/CD pipelines

---

## Use user_data for Bootstrapping

Better:
```text
cloud-native initialization
```

instead of:
```text
SSH-based provisioning
```

---

## Keep Provisioners Minimal

Good Use Cases:
- bootstrap trigger
- inventory generation
- temporary automation

---

## Never Hardcode Secrets

Avoid:
- passwords
- SSH keys
- tokens

inside Terraform code.

---

## Use Dedicated Automation Tools

Terraform:
```text
Infrastructure Provisioning
```

Ansible:
```text
Configuration Management
```

Kubernetes:
```text
Application Orchestration
```

---

# Provisioner Execution Order

Order:
```text
file
↓
remote-exec
↓
local-exec
```

based on declaration sequence.

---

# Interview Questions

## What are Terraform Provisioners?

Provisioners execute scripts/commands during resource lifecycle operations.

---

## Why are Provisioners considered last resort?

Because they:
- reduce reliability
- create non-idempotent behavior
- are difficult to debug
- are not fully state-aware

---

## Difference between local-exec and remote-exec

| Provisioner | Runs Where      |
| ----------- | --------------- |
| local-exec  | Local machine   |
| remote-exec | Remote resource |

---

## Why prefer user_data over remote-exec?

Benefits:
- cloud-native
- scalable
- idempotent
- faster provisioning

---

## What is a null_resource?

A Terraform resource used for automation workflows and provisioner execution without creating infrastructure.

---

## Why is Terraform bad for configuration management?

Terraform focuses on:
```text
Infrastructure Lifecycle
```

not:
```text
OS/Application Configuration
```

---

# Production Reality

Provisioners are heavily overused by beginners but minimized in mature production environments.

Enterprise infrastructure engineering typically separates:
- infrastructure provisioning
- configuration management
- application deployment

Modern production workflows usually combine:
- Terraform
- Packer
- Ansible
- CI/CD pipelines
- Kubernetes

instead of embedding complex operational logic inside Terraform provisioners.

Terraform should provision infrastructure, not become a full configuration management platform.
