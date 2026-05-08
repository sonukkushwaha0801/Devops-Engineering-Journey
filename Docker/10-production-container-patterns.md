# Production Container Patterns

## Overview

Production container environments require standardized deployment and operational patterns to ensure:

- Reliability
- Scalability
- Recoverability
- Security
- Observability

These patterns are widely used across:
- Kubernetes
- Docker Swarm
- ECS
- Nomad
- Modern cloud-native platforms

---

# Immutable Deployment Pattern

Production containers should never be modified after deployment.

Bad practice:
- SSH into container
- Manual package installation
- Runtime file edits

Correct approach:
- Rebuild image
- Redeploy container

---

# Immutable Infrastructure Flow

```text
Code Change
    ↓
Build New Image
    ↓
Push to Registry
    ↓
Deploy New Container
    ↓
Terminate Old Container
```

Benefits:
- Reproducibility
- Predictability
- Easier rollback

---

# Stateless Service Pattern

Application containers should remain stateless.

State should live in:
- databases
- object storage
- external caches

---

# Stateless Architecture Example

```text
API Containers
      ↓
External PostgreSQL
```

Benefits:
- Horizontal scaling
- Faster recovery
- Easier orchestration

---

# Stateful Service Pattern

Some services require persistent state.

Examples:
- PostgreSQL
- Redis persistence
- Elasticsearch

Requirements:
- persistent volumes
- backup strategy
- recovery procedures

---

# Sidecar Pattern

Additional helper container runs alongside primary container.

Common use cases:
- logging
- monitoring
- proxying
- secrets injection

---

# Sidecar Example

```text
Application Container
        +
Logging Sidecar
```

Examples:
- Fluent Bit
- Envoy
- Vault Agent

---

# Ambassador Pattern

Proxy container acts as communication intermediary.

Purpose:
- simplify external connectivity
- abstract service access

---

# Ambassador Example

```text
Application
    ↓
Ambassador Proxy
    ↓
External Database
```

---

# Init Container Pattern

Container executes initialization tasks before application starts.

Common tasks:
- migrations
- configuration generation
- permission fixes

---

# Init Flow

```text
Init Container
      ↓
Main Application Starts
```

---

# Reverse Proxy Pattern

Production traffic should pass through reverse proxy.

---

# Typical Architecture

```text
Internet
    ↓
Nginx / Traefik
    ↓
Application Containers
```

Responsibilities:
- SSL termination
- load balancing
- routing
- rate limiting

---

# Blue-Green Deployment Pattern

Two identical environments:
- Blue → current production
- Green → new version

Traffic switches after validation.

---

# Blue-Green Flow

```text
Blue Environment → Live Traffic

Green Environment → New Deployment
```

After validation:

```text
Traffic switched to Green
```

Benefits:
- near-zero downtime
- instant rollback

---

# Rolling Deployment Pattern

Gradually replace old containers with new ones.

Benefits:
- reduced downtime
- controlled rollout

Common in:
- Kubernetes
- ECS
- Swarm

---

# Canary Deployment Pattern

Deploy new version to small subset of users first.

Purpose:
- risk reduction
- real-world validation

---

# Healthcheck Pattern

Containers should expose health status.

---

# Healthcheck Example

```dockerfile
HEALTHCHECK CMD curl -f http://localhost || exit 1
```

---

# Compose Healthcheck

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 30s
  timeout: 10s
  retries: 3
```

---

# Self-Healing Pattern

Failed containers automatically restart.

---

# Restart Policy

```yaml
restart: unless-stopped
```

Benefits:
- improved resilience
- automatic recovery

---

# Logging Pattern

Containers should write logs to:
- stdout
- stderr

Avoid:
- internal container log files

---

# Centralized Logging Flow

```text
Containers
    ↓
Log Collector
    ↓
Centralized Logging Platform
```

Examples:
- ELK Stack
- Loki
- Splunk

---

# Monitoring Pattern

Production infrastructure requires:
- metrics
- alerts
- dashboards
- tracing

---

# Common Monitoring Stack

```text
Prometheus
     ↓
Grafana
```

---

# Observability Pattern

Three pillars:

| Area    | Purpose                 |
| ------- | ----------------------- |
| Logs    | Event visibility        |
| Metrics | Performance visibility  |
| Traces  | Request flow visibility |

---

# Resource Limiting Pattern

Containers must have:
- CPU limits
- memory limits

Prevents:
- noisy neighbor problems
- resource exhaustion

---

# Memory Limit Example

```yaml
deploy:
  resources:
    limits:
      memory: 512M
```

---

# CPU Limit Example

```yaml
deploy:
  resources:
    limits:
      cpus: "1"
```

---

# Secrets Management Pattern

Never embed secrets inside:
- images
- repositories
- compose files

Use:
- Vault
- Docker Secrets
- AWS Secrets Manager

---

# Network Segmentation Pattern

Separate networks by function.

Example:

| Network          | Services  |
| ---------------- | --------- |
| frontend-network | nginx     |
| backend-network  | APIs      |
| database-network | databases |

Benefits:
- isolation
- reduced attack surface

---

# Internal Service Pattern

Databases and internal APIs should not expose public ports.

Bad:

```yaml
ports:
  - "5432:5432"
```

Better:
- internal-only networking

---

# Image Versioning Pattern

Production deployments should use:
- immutable tags
- semantic versions

Avoid:
- `latest`

---

# Read-Only Filesystem Pattern

Prevent container filesystem modification.

```bash
docker run --read-only nginx
```

Benefits:
- security hardening
- malware resistance

---

# Non-Root Container Pattern

Containers should run as unprivileged users.

```dockerfile
USER appuser
```

---

# Configuration Externalization Pattern

Application configs should remain external.

Methods:
- environment variables
- mounted configs
- secret managers

---

# Horizontal Scaling Pattern

Scale stateless services horizontally.

Example:

```bash
docker compose up --scale api=3
```

---

# Queue-Based Worker Pattern

Background workers consume jobs asynchronously.

Examples:
- Celery
- RabbitMQ workers
- Kafka consumers

---

# Production Failure Handling

Production systems should tolerate:
- container crashes
- node failures
- network interruptions

---

# Graceful Shutdown Pattern

Containers should terminate cleanly.

Purpose:
- finish requests
- flush logs
- close DB connections

---

# Signal Handling

Containers should properly handle:
- SIGTERM
- SIGINT

---

# Deployment Rollback Pattern

Rollback strategy required for:
- failed deployments
- broken releases

Typical flow:

```text
Deploy New Version
      ↓
Health Validation
      ↓
Failure Detected
      ↓
Rollback Previous Image
```

---

# CI/CD Integration Pattern

Typical pipeline:

```text
Code Push
    ↓
Build Image
    ↓
Security Scan
    ↓
Push Registry
    ↓
Deploy Containers
```

---

# Infrastructure as Code Pattern

Infrastructure should be:
- declarative
- version-controlled
- reproducible

Examples:
- Compose
- Terraform
- Kubernetes manifests

---

# Common Production Anti-Patterns

| Anti-Pattern              | Risk                     |
| ------------------------- | ------------------------ |
| SSH into containers       | Configuration drift      |
| Using latest tag          | Uncontrolled deployments |
| Running as root           | Privilege escalation     |
| Storing secrets in images | Credential leakage       |
| Public database exposure  | Security breach          |

---

# Production Design Principles

## Reliability

Infrastructure must recover automatically.

---

## Scalability

Services should scale independently.

---

## Security

Least privilege and segmentation.

---

## Observability

Infrastructure should expose operational visibility.

---

## Automation

Manual operations should be minimized.

---

# Real-World Production Stack Example

```text
Internet
    ↓
Cloud Load Balancer
    ↓
Nginx Reverse Proxy
    ↓
Frontend Containers
    ↓
Backend API Containers
    ↓
PostgreSQL + Redis
    ↓
Monitoring + Logging Stack
```

---

# Important Concepts

## Cloud-Native Design

Applications designed for distributed infrastructure.

---

## Ephemeral Infrastructure

Containers treated as disposable runtime units.

---

## Immutable Releases

Deployments should be versioned and reproducible.

---

## Operational Resilience

Infrastructure should survive failures gracefully.

---
