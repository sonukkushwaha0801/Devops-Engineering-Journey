# Steps to Execute Multi-Region Deployment Task

## Step 1: Verify AWS Credentials

```bash
aws sts get-caller-identity
```

---

## Step 2: Navigate to Practice Directory

```bash
cd /path/to/Practice/16-multi-region-deployment
```

---

## Step 3: Review Multi-Region Architecture

```bash
cat architecture.md
```

Expected structure:
- **Primary Region** (us-east-1): RDS master, Application servers
- **Secondary Region** (us-west-2): RDS read replica, Application servers
- **Global**: Route 53 health checks and failover routing

---

## Step 4: Initialize Terraform

```bash
terraform init
```

---

## Step 5: Create Primary Region Infrastructure

```bash
# Plan with primary region focus
terraform plan -target='module.primary_region'

# Apply primary region
terraform apply -target='module.primary_region'
```

Wait 2-3 minutes for RDS instance to be available

---

## Step 6: Verify Primary Region Deployment

```bash
# Get primary region outputs
terraform output primary_region_outputs

# Check EC2 instances
aws ec2 describe-instances \
  --region us-east-1 \
  --filters "Name=tag:Region,Values=primary" \
  --query 'Reservations[].Instances[].[InstanceId,PublicIpAddress,State.Name]'

# Check RDS instance
aws rds describe-db-instances \
  --region us-east-1 \
  --query 'DBInstances[].[DBInstanceIdentifier,DBInstanceStatus,Endpoint.Address]'
```

---

## Step 7: Create Secondary Region Infrastructure

```bash
# Plan secondary region
terraform plan -target='module.secondary_region'

# Apply secondary region
terraform apply -target='module.secondary_region'
```

This creates read replicas and app servers in us-west-2

---

## Step 8: Verify Secondary Region Deployment

```bash
# Check secondary region EC2
aws ec2 describe-instances \
  --region us-west-2 \
  --filters "Name=tag:Region,Values=secondary" \
  --query 'Reservations[].Instances[].[InstanceId,PublicIpAddress,State.Name]'

# Check RDS read replica
aws rds describe-db-instances \
  --region us-west-2 \
  --query 'DBInstances[].[DBInstanceIdentifier,DBInstanceStatus,ReadReplicaSourceDBInstanceIdentifier]'
```

Confirm that:
- Read replica shows primary as source
- Replication lag is minimal (< 1 second)

---

## Step 9: Configure Route 53 for Failover

```bash
# Create Route 53 failover policy
terraform apply -target='aws_route53_record.primary_endpoint' \
                 -target='aws_route53_record.secondary_endpoint'
```

---

## Step 10: Test Failover Behavior

### Option A: DNS Failover Test

```bash
# Query Route 53 DNS
nslookup app.yourdomain.com

# Should return primary region IP initially
# Watch as health checks determine failover

dig app.yourdomain.com +short
```

### Option B: Simulate Primary Region Failure

```bash
# Stop primary EC2 instance
aws ec2 stop-instances \
  --region us-east-1 \
  --instance-ids i-xxxxxxxx

# Monitor Route 53 health check status (2-3 minutes)
aws route53 get-health-check-status \
  --health-check-id <health-check-id>

# DNS should now resolve to secondary region
nslookup app.yourdomain.com
```

---

## Step 11: Verify Data Replication

```bash
# Connect to primary RDS
mysql -h <primary-endpoint> -u admin -p

# Query data
SELECT * FROM replication_test;

# Connect to secondary RDS read replica
mysql -h <secondary-endpoint> -u admin -p

# Data should be identical (read-only)
SELECT * FROM replication_test;

# Replication lag
SHOW SLAVE STATUS;  # Check Seconds_Behind_Master
```

---

## Step 12: Cost Analysis

```bash
# Generate cost breakdown
terraform output cost_analysis

# Expected format:
# Region          | Service    | Monthly Cost
# us-east-1       | EC2        | $XX.XX
# us-east-1       | RDS Master | $XX.XX
# us-west-2       | EC2        | $XX.XX
# us-west-2       | RDS Replica| $XX.XX
# -------         | Total      | $XX.XX
```

---

## Step 13: Test Regional Failback (Recovery)

```bash
# Restart primary region instance
aws ec2 start-instances \
  --region us-east-1 \
  --instance-ids i-xxxxxxxx

# Wait for instance to become available (2-3 minutes)
aws ec2 wait instance-running \
  --region us-east-1 \
  --instance-ids i-xxxxxxxx

# Route 53 should automatically fail back to primary
watch -n 10 "dig app.yourdomain.com +short"
```

---

## Step 14: Document Disaster Recovery Runbook

Create `RUNBOOK.md`:

```markdown
# Disaster Recovery Runbook

## Scenario 1: Primary Region Outage
1. Monitoring detects health check failure (automatic)
2. Route 53 routes traffic to secondary region
3. Application becomes read-only (secondary = read replica)
4. RTO: ~2 minutes (health check interval)
5. Action: Promote read replica to standalone or failback

## Scenario 2: Complete Regional Failure
1. Automated failover to secondary region
2. Promote RDS read replica to standalone master
3. Update connection strings
4. Application recovers with minimal data loss

## Scenario 3: Regional Recovery
1. Repair primary region infrastructure
2. Resync data from promoted secondary
3. Failback when stable
4. Validate data consistency
```

---

## Step 15: Clean Up

```bash
# Destroy secondary region first (to prevent replication errors)
terraform destroy -target='module.secondary_region'

# Then destroy primary
terraform destroy -target='module.primary_region'

# Destroy Route 53 records
terraform destroy -target='aws_route53_zone.main'
```

---

# Key Learnings

| Concept | Production Impact |
|---------|-------------------|
| Provider aliases | Deploy to multiple regions with single config |
| Read replicas | Data redundancy without primary write conflicts |
| Health checks | Automatic failover (2-3 min RTOs) |
| Failover routing | Transparent to applications |
| Cost multi-region | 2x infrastructure + replication bandwidth |

---

# Production Multi-Region Patterns

```
┌─────────────────────────────────────┐
│        Route 53 (Global)            │
│  Failover Policy + Health Checks    │
└──────────┬────────────────┬─────────┘
           │                │
     ┌─────▼─┐         ┌────▼──┐
     │ US-EAST-1       │US-WEST-2 (Standby)
     │ PRIMARY         │
     │ ├─ App Servers  │ ├─ App Servers
     │ ├─ RDS Master   │ ├─ RDS Replica→
     │ └─ S3 Primary   │ └─ S3 Replica→
     └─────────────────┴──────────
```

---

# Interview Follow-Up Questions

1. "How do you minimize RPO in a multi-region setup?"
2. "What's the cost-benefit of multi-region vs single region with backups?"
3. "How do you handle database consistency during failover?"
4. "Design a 3-region deployment"
5. "How do you test disaster recovery without downtime?"
