# Container Security

## Overview

Containers improve deployment consistency, but they do not provide complete security isolation by default.

Production container security focuses on:
- Least privilege
- Isolation
- Attack surface reduction
- Supply chain protection
- Runtime protection

---

# Shared Kernel Risk

Containers share the host Linux kernel.

Implication:
- Kernel compromise can affect all containers

Production impact:
- Host security is critical

---

# Core Container Security Areas

| Area                  | Focus                     |
| --------------------- | ------------------------- |
| Image Security        | Secure image creation     |
| Runtime Security      | Secure running containers |
| Host Security         | Harden Docker host        |
| Network Security      | Restrict communication    |
| Secret Management     | Protect sensitive data    |
| Supply Chain Security | Trusted dependencies      |

---

# Principle of Least Privilege

Containers should have:
- Minimum permissions
- Minimal filesystem access
- Limited capabilities

Never run workloads with unnecessary privileges.

---

# Root vs Non-Root Containers

Bad practice:

```dockerfile
USER root
```

Recommended:

```dockerfile
RUN useradd -m appuser

USER appuser
```

---

# Verify Running User

```bash
docker exec CONTAINER_ID whoami
```

---

# Privileged Containers

Dangerous mode:

```bash
docker run --privileged ubuntu
```

Risks:
- Full host device access
- Kernel capability escalation
- Reduced isolation

Production recommendation:
- Avoid privileged containers

---

# Linux Namespaces

Namespaces isolate:
- Processes
- Networking
- Mount points
- Hostnames
- IPC
- Users

Container isolation is built using namespaces.

---

# cgroups

Control Groups (cgroups) limit:
- CPU
- Memory
- I/O
- Process counts

---

# Memory Limit Example

```bash
docker run -m 512m nginx
```

---

# CPU Limit Example

```bash
docker run --cpus="1" nginx
```

---

# Linux Capabilities

Linux capabilities divide root privileges into smaller units.

Examples:
- NET_ADMIN
- SYS_ADMIN
- CHOWN

Production principle:
- Drop unnecessary capabilities

---

# Drop Capabilities Example

```bash
docker run --cap-drop ALL nginx
```

Add specific capability:

```bash
docker run --cap-add NET_BIND_SERVICE nginx
```

---

# Read-Only Filesystem

Prevent filesystem modification.

```bash
docker run --read-only nginx
```

Benefits:
- Reduces malware persistence
- Prevents accidental writes

---

# Temporary Writable Storage

Use tmpfs for temporary runtime files.

```bash
docker run \
  --read-only \
  --tmpfs /tmp nginx
```

---

# Seccomp Profiles

Seccomp filters Linux syscalls.

Purpose:
- Restrict dangerous kernel operations

Docker uses default seccomp profile automatically.

---

# Custom Seccomp Profile

```bash
docker run \
  --security-opt seccomp=profile.json nginx
```

---

# AppArmor

Mandatory Access Control (MAC) system.

Restricts:
- File access
- Process capabilities
- Network operations

---

# AppArmor Example

```bash
docker run \
  --security-opt apparmor=custom-profile nginx
```

---

# SELinux

Additional Linux security layer.

Common in:
- RHEL
- CentOS
- Fedora

Provides:
- Label-based access control

---

# User Namespace Remapping

Maps container root user to unprivileged host user.

Benefits:
- Reduces host privilege exposure

---

# Enable User Namespace Remap

```json
{
  "userns-remap": "default"
}
```

Docker daemon configuration:

```text
/etc/docker/daemon.json
```

---

# Secret Management

Never store secrets inside:
- Dockerfiles
- Images
- Git repositories

Bad example:

```dockerfile
ENV DB_PASSWORD=password123
```

---

# Recommended Secret Storage

Use:
- Docker secrets
- AWS Secrets Manager
- HashiCorp Vault
- Kubernetes Secrets

---

# Docker Secrets Example

```bash
docker secret create db_password password.txt
```

---

# Image Vulnerability Scanning

Production images must be scanned regularly.

Common tools:
- Trivy
- Grype
- Snyk
- Docker Scout

---

# Trivy Scan Example

```bash
trivy image myapp:v1
```

---

# Supply Chain Security

Risks:
- Malicious dependencies
- Compromised base images
- Dependency confusion attacks

---

# Secure Base Image Practices

## Recommended Practices

- Use official images
- Pin image versions
- Avoid `latest`
- Use minimal images
- Regularly patch images

Bad:

```dockerfile
FROM ubuntu
```

Better:

```dockerfile
FROM python:3.12-slim
```

---

# Image Signing

Verifies image authenticity.

Technologies:
- Docker Content Trust
- Cosign
- Notary

---

# Enable Docker Content Trust

```bash
export DOCKER_CONTENT_TRUST=1
```

---

# Container Networking Security

Production recommendations:
- Use isolated networks
- Avoid unnecessary exposed ports
- Restrict east-west traffic
- Separate frontend/backend networks

---

# Port Exposure Risk

Bad:

```bash
-p 0.0.0.0:5432:5432
```

Safer:
- Keep databases internal-only

---

# Logging Security

Avoid logging:
- passwords
- tokens
- secrets
- credentials

---

# Runtime Monitoring

Production monitoring tools:
- Falco
- Sysdig
- CrowdStrike
- Aqua Security

Purpose:
- Detect suspicious container activity

---

# Docker Bench Security

Security auditing tool for Docker environments.

Checks:
- daemon configuration
- filesystem permissions
- container settings

---

# Run Docker Bench

```bash
docker run --net host --pid host \
  --userns host --cap-add audit_control \
  docker/docker-bench-security
```

---

# Immutable Containers

Production principle:
- Containers should not be modified after deployment

Instead:
- Rebuild image
- Redeploy container

---

# Security Hardening Checklist

## Image Security

- Minimal images
- Non-root users
- No hardcoded secrets
- Dependency scanning

---

## Runtime Security

- Resource limits
- Read-only filesystem
- Capability dropping
- No privileged mode

---

## Network Security

- Internal-only services
- Isolated networks
- Reverse proxy exposure only

---

## Host Security

- Patch OS regularly
- Restrict Docker socket access
- Harden SSH access
- Enable monitoring

---

# Docker Socket Risk

Dangerous mount:

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

Risk:
- Full Docker host control

Production recommendation:
- Avoid unless absolutely necessary

---

# Rootless Docker

Docker daemon running without root privileges.

Benefits:
- Reduced host attack surface

---

# Verify Rootless Docker

```bash
docker info
```

---

# Common Security Mistakes

| Mistake            | Risk                 |
| ------------------ | -------------------- |
| Using latest tag   | Uncontrolled updates |
| Running as root    | Privilege escalation |
| Exposing databases | External attacks     |
| Hardcoded secrets  | Credential leakage   |
| Large base images  | More vulnerabilities |

---

# Common Production Security Patterns

| Pattern              | Purpose                    |
| -------------------- | -------------------------- |
| Distroless Images    | Minimal attack surface     |
| Non-Root Containers  | Reduced privileges         |
| Read-Only Filesystem | Prevent persistence        |
| Isolated Networks    | Segmentation               |
| Secret Managers      | Secure credential handling |

---

# Troubleshooting Commands

## Inspect Container Security

```bash
docker inspect CONTAINER_ID
```

---

## Check Running User

```bash
docker exec CONTAINER_ID whoami
```

---

## View Capabilities

```bash
capsh --print
```

---

# Important Security Concepts

## Defense in Depth

Multiple security layers protecting infrastructure.

---

## Zero Trust

No service trusted automatically.

---

## Immutable Infrastructure

Replace infrastructure instead of modifying it.

---

## Supply Chain Integrity

Verify image and dependency authenticity.

---
