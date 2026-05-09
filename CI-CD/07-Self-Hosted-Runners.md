# Self-Hosted Runners

## Overview

Self-hosted runners are custom-managed execution environments used to run CI/CD workloads outside of vendor-managed infrastructure.

Unlike GitHub-hosted runners, self-hosted runners provide:
- infrastructure control
- private network access
- custom runtime environments
- dedicated compute resources
- workload isolation

Production engineering teams commonly use self-hosted runners for:
- internal deployments
- Kubernetes operations
- cloud infrastructure provisioning
- high-performance builds
- compliance-controlled workloads

Self-hosted runners become part of critical production infrastructure and require operational governance similar to application platforms.

---

# Why Self-Hosted Runners Exist

GitHub-hosted runners are suitable for many CI workloads but introduce operational limitations.

Common limitations:
- restricted network access
- runtime limits
- shared infrastructure
- limited customization
- external dependency risks

Production systems often require:
- VPC/private network access
- internal database connectivity
- deployment into private infrastructure
- custom build tooling
- isolated execution environments

Self-hosted runners solve these operational constraints.

---

# Common Production Use Cases

Self-hosted runners are frequently used for:

| Use Case                           | Example                      |
| ---------------------------------- | ---------------------------- |
| Private infrastructure deployments | internal Kubernetes clusters |
| Cloud provisioning                 | Terraform execution          |
| Secure networking                  | private VPC access           |
| High-performance builds            | large container builds       |
| Compliance workloads               | regulated infrastructure     |
| GPU workloads                      | ML pipelines                 |

---

# Runner Architecture

A self-hosted runner acts as a worker node that receives and executes jobs from GitHub Actions.

Basic architecture:

```text
GitHub Actions
        ↓
Runner Registration
        ↓
Job Assignment
        ↓
Local Runner Execution
        ↓
Result Reporting
```

Runner systems commonly execute:
- shell commands
- Docker workloads
- deployment automation
- infrastructure provisioning

---

# Runner Deployment Models

Self-hosted runners can be deployed using different infrastructure models.

---

# Virtual Machine Runners

Common deployment targets:
- AWS EC2
- Azure VM
- Google Compute Engine

Advantages:
- infrastructure isolation
- persistent tooling
- dedicated resources

Disadvantages:
- manual scaling
- patch management
- infrastructure maintenance

Suitable for:
- low-medium CI workloads
- infrastructure deployment automation

---

# Containerized Runners

Runners execute inside containers.

Common platforms:
- Docker
- Kubernetes

Advantages:
- lightweight execution
- rapid provisioning
- environment consistency

Disadvantages:
- container orchestration complexity
- networking considerations

Frequently used in:
- Kubernetes-native environments
- ephemeral runner systems

---

# Kubernetes-Based Runners

Large-scale environments commonly deploy runners dynamically inside Kubernetes clusters.

Typical architecture:

```text
GitHub Actions
        ↓
Runner Controller
        ↓
Ephemeral Runner Pod
        ↓
Job Execution
        ↓
Pod Destruction
```

Benefits:
- horizontal scaling
- workload isolation
- ephemeral execution
- reduced persistence risks

Popular tooling:
- Actions Runner Controller (ARC)

---

# Persistent vs Ephemeral Runners

Runner lifecycle design significantly impacts security and scalability.

---

## Persistent Runners

Long-running runner systems reused across jobs.

Advantages:
- faster execution
- pre-installed tooling
- lower startup latency

Risks:
- environment contamination
- persistence-based attacks
- dependency drift

Persistent runners require:
- regular cleanup
- patch management
- strong isolation controls

---

## Ephemeral Runners

Temporary runners created per job execution.

Workflow:

```text
Create Runner
      ↓
Execute Job
      ↓
Destroy Runner
```

Advantages:
- improved isolation
- reduced persistence risk
- cleaner execution environment

Disadvantages:
- higher provisioning overhead
- startup latency

Ephemeral runners are considered production best practice for secure CI systems.

---

# Runner Registration

Self-hosted runners register with GitHub repositories or organizations.

Registration scopes:
- repository-level
- organization-level
- enterprise-level

Production environments commonly prefer:
- organization-level centralized runner management

Registration requires:
- authentication token
- secure connectivity
- runner labeling

---

# Runner Labels

Labels define workload targeting rules.

Example:

```text
linux
docker
production
kubernetes
```

Workflow example:

```yaml
runs-on: [self-hosted, docker]
```

Benefits:
- workload specialization
- infrastructure segmentation
- deployment targeting

---

# Runner Security

Self-hosted runners are highly privileged systems and require strict hardening.

---

# Common Security Risks

| Risk                    | Impact                       |
| ----------------------- | ---------------------------- |
| Persistent compromise   | malicious code persistence   |
| Credential exposure     | infrastructure access        |
| Shared workloads        | cross-pipeline contamination |
| Overprivileged runners  | lateral movement             |
| Untrusted pull requests | arbitrary code execution     |

Self-hosted runners should be treated as sensitive infrastructure assets.

---

# Network Isolation

Production runners should operate within isolated network boundaries.

Common isolation approaches:
- private subnets
- VPC segmentation
- restricted ingress
- firewall controls

Benefits:
- reduced exposure
- controlled infrastructure access
- improved deployment security

Never expose runners directly to unrestricted public access.

---

# Least Privilege Access

Runners should only receive required permissions.

Examples:
- scoped IAM roles
- restricted deployment credentials
- isolated cloud access

Avoid:
- administrative cloud credentials
- unrestricted SSH access
- shared production secrets

Overprivileged runners significantly increase infrastructure risk.

---

# Secrets Handling

Runners frequently process:
- cloud credentials
- deployment tokens
- SSH keys
- registry authentication

Security requirements:
- encrypted secret storage
- runtime-only injection
- no persistent storage

Secrets should never:
- remain on disk permanently
- appear in logs
- exist inside container images

---

# Runner Hardening

Production runner hardening commonly includes:
- automatic patching
- minimal installed packages
- restricted sudo access
- monitoring agents
- filesystem isolation

Additional controls:
- antivirus/EDR tooling
- immutable infrastructure
- container sandboxing

---

# Scaling Self-Hosted Runners

Large CI systems require automated runner scaling.

Scaling methods:
- auto-scaling VM groups
- Kubernetes-based scaling
- event-driven provisioning

Scaling goals:
- minimize queue time
- optimize infrastructure cost
- handle workload spikes

Poor scaling creates:
- deployment delays
- infrastructure bottlenecks

---

# Runner Monitoring

Production runners require continuous monitoring.

Monitoring areas:
- CPU utilization
- memory consumption
- disk usage
- job execution failures
- queue latency

Common tooling:
- Prometheus
- Grafana
- Datadog
- CloudWatch

Runner observability is critical for stable CI operations.

---

# Runner Maintenance

Self-hosted infrastructure requires operational maintenance.

Maintenance responsibilities:
- OS patching
- dependency updates
- runner upgrades
- security hardening
- log management

Neglected runners become security liabilities.

---

# Caching Strategies

Self-hosted runners commonly implement caching for:
- dependencies
- Docker layers
- Terraform plugins
- package managers

Benefits:
- reduced build time
- lower bandwidth usage
- faster pipeline execution

Tradeoff:
- stale dependency risk

---

# Deployment Integration

Self-hosted runners are commonly integrated with:
- Kubernetes clusters
- Terraform automation
- Docker registries
- internal APIs
- cloud infrastructure

Typical deployment flow:

```text
GitHub Workflow
       ↓
Self-Hosted Runner
       ↓
Infrastructure Authentication
       ↓
Deployment Execution
       ↓
Health Validation
```

---

# Cost Considerations

Self-hosted runners shift operational cost responsibility to engineering teams.

Cost areas:
- compute resources
- storage
- networking
- maintenance effort
- monitoring infrastructure

Benefits:
- predictable scaling
- dedicated performance
- infrastructure ownership

Large-scale environments commonly optimize:
- ephemeral execution
- auto-scaling
- workload scheduling

---

# Common Operational Failures

Frequent runner-related failures include:

| Failure               | Impact                  |
| --------------------- | ----------------------- |
| Runner offline        | failed pipelines        |
| Disk exhaustion       | build failures          |
| Dependency drift      | inconsistent execution  |
| Network issues        | deployment interruption |
| Credential expiration | authentication failure  |

Operational governance is essential for runner reliability.

---

# Production Best Practices

Recommended engineering practices:

- prefer ephemeral runners
- isolate production workloads
- implement auto-scaling
- harden runner infrastructure
- monitor runner health
- rotate credentials regularly
- use least privilege access
- avoid shared mutable environments
- patch runners continuously
- separate CI and deployment runners

Production CI systems should minimize runner persistence wherever possible.

---

# Future Direction

Modern CI platforms increasingly move toward:
- ephemeral infrastructure
- container-native runners
- serverless execution
- workload isolation
- zero-trust CI architecture

Kubernetes-based ephemeral runners are becoming the dominant large-scale deployment model.

---

# Conclusion

Self-hosted runners provide infrastructure flexibility and operational control for advanced CI/CD systems.

They enable:
- private infrastructure access
- secure deployment automation
- scalable execution environments
- customized runtime systems

However, self-hosted runners also introduce:
- infrastructure management overhead
- operational maintenance
- security responsibility

Production-grade runner infrastructure requires:
- isolation
- automation
- observability
- hardening
- scalable orchestration

Reliable CI/CD systems depend heavily on secure and properly managed runner infrastructure.
