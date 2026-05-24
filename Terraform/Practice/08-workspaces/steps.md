# Steps to Execute the Task

# Step 1: Verify AWS Authentication

```bash
aws sts get-caller-identity
```

---

# Step 2: Move into Practice Directory

```bash
cd Devops-Engineering-Journey/Terraform/Practice/08-workspaces
```

---

# Step 3: Verify Files

```bash
ls
```

Expected:
```text
provider.tf
variables.tf
terraform.tfvars
main.tf
outputs.tf
backend.tf
```

---

# Step 4: Initialize Terraform

```bash
terraform init
```

Purpose:
- initialize Terraform
- initialize backend
- download providers

---

# Step 5: Verify Current Workspace

```bash
terraform workspace show
```

Expected:
```text
default
```

---

# Step 6: List Existing Workspaces

```bash
terraform workspace list
```

Expected:
```text
* default
```

---

# Step 7: Create Dev Workspace

```bash
terraform workspace new dev
```

---

# Step 8: Create Prod Workspace

```bash
terraform workspace new prod
```

---

# Step 9: List Workspaces Again

```bash
terraform workspace list
```

Expected:
```text
default
dev
prod
```

---

# Step 10: Switch to Dev Workspace

```bash
terraform workspace select dev
```

Verify:
```bash
terraform workspace show
```

Expected:
```text
dev
```

---

# Step 11: Generate Terraform Plan

```bash
terraform plan
```

Observe:
- workspace-aware tags
- environment-based naming
- dynamic instance type selection

---

# Step 12: Apply Dev Infrastructure

```bash
terraform apply
```

Type:
```text
yes
```

---

# Step 13: Verify Dev Infrastructure

Check outputs:
```bash
terraform output
```

Verify EC2 in AWS Console:
```text
dev-frontend
```

---

# Step 14: Switch to Prod Workspace

```bash
terraform workspace select prod
```

---

# Step 15: Apply Prod Infrastructure

```bash
terraform apply
```

Type:
```text
yes
```

Observe:
- separate infrastructure
- separate Terraform state
- different instance type

---

# Step 16: Verify Workspace Isolation

Check:
```bash
terraform workspace show
```

AND:
```bash
terraform state list
```

Each workspace maintains:
```text
separate state
```

---

# Step 17: Verify Local Workspace State Files

Command:
```bash
tree terraform.tfstate.d
```

Expected:
```text
terraform.tfstate.d/
├── dev/
└── prod/
```

---

# Step 18: Destroy Dev Infrastructure

Switch:
```bash
terraform workspace select dev
```

Destroy:
```bash
terraform destroy
```

---

# Step 19: Destroy Prod Infrastructure

Switch:
```bash
terraform workspace select prod
```

Destroy:
```bash
terraform destroy
```

---

# Common Errors

## Workspace already exists

Fix:
```bash
terraform workspace list
```

---

## Wrong environment infrastructure

Reason:
Wrong active workspace.

Fix:
Verify:
```bash
terraform workspace show
```

---

## State confusion

Reason:
Infrastructure deployed in different workspace.

Fix:
Switch workspace correctly.

---

# Production Note

Terraform workspaces are useful for:
- lightweight environment isolation
- sandbox environments
- reusable infrastructure testing

Large enterprises often prefer:
- separate AWS accounts
- separate backends
- separate CI/CD pipelines
