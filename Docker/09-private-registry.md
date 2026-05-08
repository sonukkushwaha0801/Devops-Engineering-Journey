# Private Docker Registry

## Overview

Docker registries store and distribute container images.

Production environments use registries for:
- Centralized image storage
- Version management
- CI/CD deployments
- Access control
- Secure image distribution

---

# Registry Types

| Registry Type          | Example         |
| ---------------------- | --------------- |
| Public Registry        | Docker Hub      |
| Private Cloud Registry | AWS ECR         |
| Self-Hosted Registry   | Docker Registry |
| Enterprise Registry    | Harbor          |

---

# Common Production Registries

| Registry                  | Provider    |
| ------------------------- | ----------- |
| Docker Hub                | Docker      |
| Amazon ECR                | AWS         |
| GitHub Container Registry | GitHub      |
| Google Artifact Registry  | GCP         |
| Azure Container Registry  | Azure       |
| Harbor                    | Self-hosted |

---

# Registry Workflow

```text
Build Image
     ↓
Tag Image
     ↓
Push to Registry
     ↓
Pull During Deployment
```

---

# Docker Hub Authentication

Login:

```bash
docker login
```

Logout:

```bash
docker logout
```

---

# Image Tagging

Before pushing, images must be tagged correctly.

---

# Tag Image

```bash
docker tag myapp:v1 username/myapp:v1
```

Format:

```text
REGISTRY/IMAGE_NAME:TAG
```

---

# Push Image

```bash
docker push username/myapp:v1
```

---

# Pull Image

```bash
docker pull username/myapp:v1
```

---

# Avoid latest Tag

Bad:

```text
myapp:latest
```

Better:

```text
myapp:v1.2.0
```

Benefits:
- Predictable deployments
- Easier rollback
- Version traceability

---

# Semantic Versioning

Recommended format:

```text
MAJOR.MINOR.PATCH
```

Example:

```text
v2.1.5
```

---

# GitHub Container Registry (GHCR)

Registry provided by GitHub.

Registry URL:

```text
ghcr.io
```

---

# GHCR Login

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

---

# GHCR Tag Example

```bash
docker tag myapp:v1 ghcr.io/username/myapp:v1
```

---

# Push to GHCR

```bash
docker push ghcr.io/username/myapp:v1
```

---

# AWS Elastic Container Registry (ECR)

Managed private container registry from AWS.

Benefits:
- IAM integration
- High availability
- Native AWS ecosystem support

---

# Authenticate to ECR

```bash
aws ecr get-login-password \
| docker login \
--username AWS \
--password-stdin ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com
```

---

# Tag for ECR

```bash
docker tag myapp:v1 \
ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/myapp:v1
```

---

# Push to ECR

```bash
docker push \
ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/myapp:v1
```

---

# Self-Hosted Docker Registry

Docker provides official registry image.

---

# Run Local Registry

```bash
docker run -d \
  -p 5000:5000 \
  --name registry \
  registry:2
```

---

# Push to Local Registry

```bash
docker tag myapp:v1 localhost:5000/myapp:v1

docker push localhost:5000/myapp:v1
```

---

# Pull from Local Registry

```bash
docker pull localhost:5000/myapp:v1
```

---

# Registry Authentication

Production registries require:
- authentication
- authorization
- encrypted communication

---

# Registry Access Control

Best practices:
- Role-based access
- Least privilege
- Separate CI/CD credentials
- Avoid shared accounts

---

# CI/CD Registry Integration

Typical pipeline:

```text
Git Push
    ↓
CI Pipeline
    ↓
Build Docker Image
    ↓
Push to Registry
    ↓
Deployment Pulls Image
```

---

# GitHub Actions Example

```yaml
- name: Login to GHCR
  run: echo "${{ secrets.GITHUB_TOKEN }}" \
    | docker login ghcr.io -u USERNAME --password-stdin

- name: Build Image
  run: docker build -t ghcr.io/username/myapp:v1 .

- name: Push Image
  run: docker push ghcr.io/username/myapp:v1
```

---

# Registry Security

Production registries should enforce:
- HTTPS/TLS
- authentication
- image scanning
- access logging

---

# Image Vulnerability Scanning

Many registries support:
- automated scanning
- CVE detection
- policy enforcement

Examples:
- ECR scanning
- Docker Scout
- Harbor scanning

---

# Image Signing

Ensures image authenticity.

Technologies:
- Cosign
- Notary
- Docker Content Trust

---

# Enable Docker Content Trust

```bash
export DOCKER_CONTENT_TRUST=1
```

---

# Registry Cleanup

Unused images increase:
- storage costs
- security exposure

---

# Remove Local Images

```bash
docker image prune
```

---

# Registry Retention Policies

Production registries commonly implement:
- tag retention
- automatic cleanup
- lifecycle policies

---

# AWS ECR Lifecycle Policies

Used for:
- deleting old images
- reducing storage costs

---

# Multi-Environment Tagging

Recommended tagging strategy:

| Environment | Example       |
| ----------- | ------------- |
| Development | myapp:dev     |
| Staging     | myapp:staging |
| Production  | myapp:v1.0.0  |

---

# Immutable Tags

Production recommendation:
- Avoid overwriting existing tags

Benefits:
- safer rollback
- deployment consistency

---

# Air-Gapped Registry Concepts

Some enterprise environments:
- block internet access
- use internal registries only

Purpose:
- security compliance
- supply chain control

---

# Registry Replication

Enterprise registries may replicate images across:
- regions
- data centers

Benefits:
- redundancy
- faster deployments
- disaster recovery

---

# Production Registry Best Practices

## Recommended Practices

- Use private registries
- Enable image scanning
- Use explicit version tags
- Enforce authentication
- Use TLS
- Automate cleanup policies
- Use immutable tagging
- Integrate with CI/CD

---

# Common Registry Mistakes

| Mistake                 | Risk                     |
| ----------------------- | ------------------------ |
| Using latest tag        | Uncontrolled deployments |
| Public sensitive images | Data exposure            |
| No cleanup policy       | Storage growth           |
| Hardcoded credentials   | Credential leakage       |
| Untrusted base images   | Supply chain risk        |

---

# Common Production Registry Patterns

| Pattern             | Purpose                 |
| ------------------- | ----------------------- |
| CI/CD Push Pipeline | Automated delivery      |
| Private Registry    | Controlled access       |
| Immutable Tags      | Predictable deployment  |
| Automated Scanning  | Vulnerability detection |
| Lifecycle Policies  | Cost optimization       |

---

# Troubleshooting Commands

## Verify Login

```bash
docker info
```

---

## List Local Images

```bash
docker images
```

---

## Pull Test

```bash
docker pull IMAGE_NAME
```

---

## Push Test

```bash
docker push IMAGE_NAME
```

---

# Important Concepts

## Artifact Management

Container images are deployment artifacts.

---

## Supply Chain Security

Verify integrity of images and dependencies.

---

## Immutable Releases

Production images should remain unchanged after publishing.

---

## Deployment Reproducibility

Same image should deploy consistently everywhere.

---

# Example Production Workflow

```text
Developer Push
      ↓
CI Pipeline
      ↓
Docker Build
      ↓
Security Scan
      ↓
Push to Private Registry
      ↓
Deployment Pulls Image
```

---
