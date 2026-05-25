# Task: Multi-Region Terraform Deployment

# Objective

Design & deploy applications across multiple AWS regions using:
- Provider aliases for multi-region
- Cross-region replication
- Global load balancing
- Region-specific configurations
- State management across regions

---

# Infrastructure Goal

You will:
1. **Deploy VPC + EC2** in primary region (us-east-1)
2. **Deploy replica infrastructure** in secondary region (us-west-2)
3. **Configure Route 53** for failover/routing
4. **Implement cross-region replication** (S3, RDS read replicas)
5. **Test failover scenarios**
6. **Document region-specific costs**

---

# Concepts Covered

- Provider aliases
- Multiple provider instances
- `for_each` with regions
- Cross-region dependencies
- Route 53 health checks
- Regional failover
- State isolation per region
- Cost optimization

---

# AWS Services Used

| Service | Purpose | Regions |
|---------|---------|---------|
| EC2     | Compute | us-east-1, us-west-2 |
| Route 53 | DNS/Failover | Global |
| RDS     | Database | us-east-1 (primary) + us-west-2 (replica) |
| S3      | Storage | us-east-1 (primary) + replication |

---

# Expected Result

After execution:
- Dual-region infrastructure deployed
- Automatic failover configured
- Cross-region replication active
- Health checks monitoring endpoints
- Cost breakdown per region
- Disaster recovery workflow documented

---

# Why This Matters (Interview Context)

**Production Scenario**: Your application is in us-east-1. A regional outage occurs. Leadership asks:
- "How do we survive region-wide failures?"
- "How long is our RTO/RPO?"
- "What's the cost of multi-region?"

**Interview Question**: "Design a multi-region deployment with automatic failover"

**Follow-ups**:
- "How do you handle data consistency?"
- "What's your disaster recovery strategy?"
- "How do you minimize failover time?"
- "How do you test failover without affecting production?"
