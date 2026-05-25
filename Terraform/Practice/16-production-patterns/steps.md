# Steps to Execute Production Patterns Task

## Step 1: Verify AWS & Local Setup

```bash
# Check AWS credentials
aws sts get-caller-identity

# Check Terraform version (1.0+)
terraform version

# Install policy checker (optional but recommended)
# brew install tfsec

# Or: wget https://github.com/aquasecurity/tfsec/releases/download/v1.28.0/tfsec-linux-amd64
```

---

## Step 2: Navigate to Practice Directory

```bash
cd /path/to/Practice/17-production-patterns
```

---

## Step 3: Create S3 Bucket for Remote State

```bash
# Create state backend bucket
aws s3api create-bucket \
  --bucket "terraform-state-$(date +%s)" \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket "terraform-state-$(date +%s)" \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket "terraform-state-$(date +%s)" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Block public access
aws s3api put-public-access-block \
  --bucket "terraform-state-$(date +%s)" \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "Bucket created and configured!"
```

---

## Step 4: Create DynamoDB Table for State Locking

```bash
# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

# Wait for table to be active
aws dynamodb wait table-exists \
  --table-name terraform-state-lock

echo "DynamoDB lock table created!"
```

---

## Step 5: Configure Remote Backend

Update `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-YOUR-BUCKET-NAME"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

Then reinitialize:

```bash
terraform init
# Answer 'yes' to migrate state to S3
```

---

## Step 6: Review Module Structure

```bash
# Expected structure:
# .
# ├── modules/
# │   ├── networking/      # VPC, subnets, security groups
# │   ├── compute/         # EC2, ASG, ALB
# │   ├── database/        # RDS, DynamoDB
# │   └── monitoring/      # CloudWatch, alarms
# ├── environments/
# │   ├── dev/
# │   ├── staging/
# │   └── prod/
# └── infrastructure.tf

tree modules/
```

---

## Step 7: Create Dev Environment

```bash
# Create dev workspace
terraform workspace new dev

# Switch to dev workspace
terraform workspace select dev

# Apply dev configuration
terraform apply -var-file="environments/dev.tfvars"
```

Expected: Small-scale infrastructure (t2.micro, no HA)

---

## Step 8: Create Staging Environment

```bash
terraform workspace new staging
terraform workspace select staging
terraform apply -var-file="environments/staging.tfvars"
```

Expected: Medium-scale infrastructure (t3.small, single AZ)

---

## Step 9: Create Production Environment

```bash
terraform workspace new prod
terraform workspace select prod

# Production requires manual approval
terraform plan -var-file="environments/prod.tfvars" -out=prod.tfplan

# Review the plan carefully!
terraform apply prod.tfplan
```

Expected: Full-scale infrastructure (t3.medium+, multi-AZ, HA)

---

## Step 10: Verify Workspace Isolation

```bash
# List workspaces
terraform workspace list

# Each workspace has separate state
terraform workspace select dev
terraform output

terraform workspace select prod
terraform output

# Different infrastructure!
```

---

## Step 11: Run Policy Checks (tfsec)

```bash
# Scan for security issues
tfsec . --format sarif --output tfsec-report.sarif

# Or simple output:
tfsec . --minimum-severity WARNING
```

Expected checks:
- [ ] S3 public access blocked
- [ ] RDS encryption enabled
- [ ] VPC Flow Logs enabled
- [ ] IAM policies least privilege

---

## Step 12: Implement Cost Tracking

```bash
# Get estimated costs per workspace
terraform workspace select dev
terraform plan -json | jq '.resource_changes[] | select(.type=="aws_instance")'

# For all workspaces:
for workspace in $(terraform workspace list | grep -v default); do
  echo "=== $workspace ==="
  terraform workspace select $workspace
  terraform plan -var-file="environments/${workspace}.tfvars" -out=${workspace}.tfplan
  terraform show -json ${workspace}.tfplan | jq '.values.root_module.resources[] | select(.type=="aws_instance") | .address'
done
```

---

## Step 13: Document Runbooks

Create `RUNBOOKS.md`:

```markdown
# Production Runbooks

## Emergency: Rollback Failed Deployment

1. Check state status: `terraform show`
2. Review previous state: `aws s3 ls s3://terraform-state-bucket/prod/`
3. Restore from backup: `aws s3 cp s3://terraform-state-bucket/prod/terraform.tfstate.backup terraform.tfstate`
4. Verify: `terraform plan`
5. Apply rollback: `terraform apply`

## Standard: Deploy to Production

1. Switch to prod workspace: `terraform workspace select prod`
2. Plan: `terraform plan -var-file=environments/prod.tfvars -out=prod.tfplan`
3. Review with team (peer approval)
4. Apply: `terraform apply prod.tfplan`
5. Test endpoints
6. Monitor CloudWatch alarms

## Policy Violation: State Lock Stuck

1. List locks: `aws dynamodb scan --table-name terraform-state-lock`
2. Force unlock: `terraform force-unlock <LOCK_ID>`
3. Investigate cause
4. Retry operation

## Disaster: State File Corrupted

1. Stop all terraform operations
2. Restore from S3 versioning: `aws s3api get-object --bucket terraform-state-bucket --key prod/terraform.tfstate --version-id <VERSION_ID> terraform.tfstate`
3. Verify: `terraform state list`
4. Run `terraform plan` (no changes expected)
```

---

## Step 14: Implement CI/CD Validation (GitHub Actions Example)

Create `.github/workflows/terraform-validate.yml`:

```yaml
name: Terraform Validate

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: hashicorp/setup-terraform@v2

      - name: Format check
        run: terraform fmt -check -recursive

      - name: Init
        run: terraform init -backend=false

      - name: Validate
        run: terraform validate

      - name: Policy check
        run: tfsec . --minimum-severity WARNING
```

---

## Step 15: Clean Up

```bash
# Destroy environments in reverse order (prod -> staging -> dev)
terraform workspace select prod
terraform destroy -var-file="environments/prod.tfvars"

terraform workspace select staging
terraform destroy -var-file="environments/staging.tfvars"

terraform workspace select dev
terraform destroy -var-file="environments/dev.tfvars"

# Delete default workspace remote state
terraform workspace select default
terraform destroy

# Delete S3 bucket and DynamoDB table
aws s3 rb s3://terraform-state-bucket --force
aws dynamodb delete-table --table-name terraform-state-lock
```

---

# Production Deployment Checklist

- [ ] Remote state configured with S3 + DynamoDB
- [ ] State versioning and backup enabled
- [ ] Multiple workspaces for env separation
- [ ] Reusable modules in /modules
- [ ] Cost estimation documented
- [ ] Security policies validated (tfsec)
- [ ] Runbooks documented
- [ ] CI/CD validation gates implemented
- [ ] Team access controls configured
- [ ] Disaster recovery tested

---

# Key Learnings

| Pattern | Production Impact |
|---------|-------------------|
| Remote state | Team collaboration + audit trail |
| Workspace isolation | Environment consistency |
| Modules | Code reuse + reduced maintenance |
| Cost tracking | Budget control + optimization |
| Policy checks | Compliance + security |
| Runbooks | Faster incident response |
| CI/CD validation | Prevent bad deployments |

---

# Interview Follow-Up Questions

1. "Design remote state structure for 5 teams, 3 regions"
2. "How do you handle state conflicts?"
3. "What's your change control process?"
4. "How do you enable safe parallel deployments?"
5. "Describe your disaster recovery procedure"
