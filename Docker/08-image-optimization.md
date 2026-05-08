# Docker Image Optimization

## Overview

Image optimization focuses on:
- Smaller image size
- Faster build times
- Faster deployments
- Reduced attack surface
- Improved CI/CD efficiency

Production environments prioritize optimized images because:
- Registry transfers become faster
- Startup time improves
- Vulnerabilities reduce
- Infrastructure costs decrease

---

# Why Image Optimization Matters

| Problem            | Impact               |
| ------------------ | -------------------- |
| Large images       | Slow deployments     |
| Too many layers    | Poor caching         |
| Heavy dependencies | More vulnerabilities |
| Unoptimized builds | Slow CI/CD           |

---

# Image Optimization Goals

Production-grade images should be:
- Minimal
- Reproducible
- Secure
- Fast to build
- Fast to pull

---

# Check Image Size

```bash
docker images
```

---

# Inspect Image Layers

```bash
docker history IMAGE_NAME
```

---

# Use Minimal Base Images

Large base images increase:
- vulnerabilities
- storage usage
- pull times

---

# Bad Example

```dockerfile
FROM ubuntu
```

---

# Better Example

```dockerfile
FROM python:3.12-slim
```

---

# Lightweight Base Images

| Image Type | Use Case          |
| ---------- | ----------------- |
| alpine     | Minimal Linux     |
| slim       | Reduced runtime   |
| distroless | Maximum hardening |

---

# Alpine Images

Small Linux distribution commonly used for containers.

Example:

```dockerfile
FROM alpine
```

Advantages:
- Very small size
- Fast downloads

Tradeoffs:
- musl libc compatibility issues
- debugging limitations

---

# Distroless Images

Contain only:
- application
- runtime dependencies

No:
- shell
- package manager
- debugging tools

---

# Distroless Example

```dockerfile
FROM gcr.io/distroless/python3
```

Benefits:
- Smaller attack surface
- Better security posture

---

# Multi-Stage Builds

One of the most important optimization techniques.

Purpose:
- Separate build environment from runtime environment

---

# Multi-Stage Build Example

```dockerfile
FROM python:3.12 AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /app /app

CMD ["python", "app.py"]
```

---

# Benefits of Multi-Stage Builds

| Benefit         | Description         |
| --------------- | ------------------- |
| Smaller images  | Removes build tools |
| Better security | Fewer packages      |
| Faster pulls    | Reduced size        |
| Cleaner runtime | Minimal environment |

---

# Layer Optimization

Each Dockerfile instruction creates a layer.

Too many layers:
- increase complexity
- reduce efficiency

---

# Combine RUN Instructions

Bad:

```dockerfile
RUN apt update
RUN apt install -y curl
RUN apt install -y git
```

Better:

```dockerfile
RUN apt update && \
    apt install -y curl git
```

---

# Remove Package Cache

Bad:

```dockerfile
RUN apt update && apt install -y curl
```

Better:

```dockerfile
RUN apt update && \
    apt install -y curl && \
    rm -rf /var/lib/apt/lists/*
```

---

# Layer Caching Strategy

Docker caches layers sequentially.

Optimization rule:
- Stable layers first
- Frequently changing code later

---

# Poor Ordering

```dockerfile
COPY . .

RUN pip install -r requirements.txt
```

Problem:
- Entire dependency layer rebuilds after code changes

---

# Better Ordering

```dockerfile
COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .
```

---

# .dockerignore

Reduces build context size.

---

# Example .dockerignore

```text
.git
venv/
node_modules/
__pycache__/
logs/
```

Benefits:
- Faster builds
- Smaller context
- Reduced accidental exposure

---

# Build Context Optimization

Large contexts slow:
- image builds
- CI/CD pipelines

Check context during build:

```bash
docker build .
```

---

# Use Explicit Dependency Versions

Bad:

```text
flask
```

Better:

```text
flask==3.0.3
```

Benefits:
- Reproducibility
- Stable builds

---

# Avoid Unnecessary Packages

Do not install:
- editors
- debugging tools
- unused libraries

inside production images.

---

# Use Non-Root User

Optimization includes security optimization.

---

# Non-Root Example

```dockerfile
RUN useradd -m appuser

USER appuser
```

Benefits:
- Reduced attack surface
- Better runtime isolation

---

# Copy Only Required Files

Bad:

```dockerfile
COPY . .
```

Better:

```dockerfile
COPY app.py .
COPY requirements.txt .
```

---

# Minimize Runtime Dependencies

Build tools should not exist in production image.

Examples:
- gcc
- make
- build-essential

---

# Python Optimization Example

```dockerfile
RUN pip install --no-cache-dir -r requirements.txt
```

Benefits:
- Prevents pip cache storage
- Smaller image size

---

# Node.js Optimization Example

```dockerfile
RUN npm ci --only=production
```

---

# BuildKit

Modern Docker build engine.

Advantages:
- Parallel builds
- Better caching
- Faster builds
- Secret support

---

# Enable BuildKit

```bash
export DOCKER_BUILDKIT=1
```

---

# Build Without Cache

```bash
docker build --no-cache .
```

Used for:
- clean rebuilds
- debugging

---

# Image Scanning

Optimization also includes vulnerability reduction.

---

# Scan Image Example

```bash
trivy image myapp:v1
```

---

# Remove Unused Images

```bash
docker image prune
```

---

# Remove All Unused Objects

```bash
docker system prune -a
```

---

# Compare Image Sizes

```bash
docker images
```

---

# Production Optimization Practices

## Recommended Practices

- Use slim/distroless images
- Use multi-stage builds
- Minimize layers
- Remove caches
- Use `.dockerignore`
- Avoid unnecessary tools
- Pin dependency versions
- Use non-root users

---

# CI/CD Optimization

Smaller images improve:
- pipeline speed
- deployment speed
- rollback speed

---

# Registry Optimization

Smaller images reduce:
- registry storage
- bandwidth usage
- transfer costs

---

# Security Optimization

Smaller images generally mean:
- fewer packages
- fewer vulnerabilities
- reduced attack surface

---

# Common Optimization Mistakes

| Mistake                      | Impact               |
| ---------------------------- | -------------------- |
| Using ubuntu base            | Large image          |
| Installing unnecessary tools | More vulnerabilities |
| Poor layer ordering          | Slow builds          |
| No `.dockerignore`           | Large build context  |
| Running as root              | Security risk        |

---

# Common Production Patterns

| Pattern            | Purpose               |
| ------------------ | --------------------- |
| Multi-stage builds | Smaller runtime image |
| Distroless runtime | Security hardening    |
| Slim images        | Reduced footprint     |
| BuildKit           | Faster builds         |
| Dependency pinning | Reproducibility       |

---

# Troubleshooting Commands

## Inspect Layers

```bash
docker history IMAGE_NAME
```

---

## Inspect Image Metadata

```bash
docker image inspect IMAGE_NAME
```

---

## Check Disk Usage

```bash
docker system df
```

---

# Important Concepts

## Reproducible Builds

Same source should generate identical images.

---

## Immutable Images

Images should never be modified after build.

---

## Minimal Attack Surface

Fewer packages reduce exploit opportunities.

---

## Efficient CI/CD

Optimized images accelerate delivery pipelines.

---

# Example Production-Grade Optimized Dockerfile

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m appuser

USER appuser

EXPOSE 8000

CMD ["python", "app.py"]
```

---
