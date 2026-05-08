# Custom Docker Images

## Overview

Custom Docker images allow packaging applications with:
- Runtime dependencies
- Application source code
- System packages
- Configurations

Production-grade image engineering focuses on:
- Security
- Small image size
- Fast builds
- Reproducibility
- Minimal attack surface

---

# Dockerfile

A `Dockerfile` is a declarative blueprint used to build Docker images.

Build flow:

```text
Dockerfile
    ↓
docker build
    ↓
Docker Image
```

---

# Basic Dockerfile

```dockerfile
FROM nginx

COPY . /usr/share/nginx/html
```

---

# Docker Build

```bash
docker build -t myapp .
```

---

# Image Layers

Each Dockerfile instruction creates a filesystem layer.

Example:

```dockerfile
FROM ubuntu
RUN apt update
RUN apt install -y nginx
COPY . /app
```

Layers:
- Base image layer
- apt update layer
- nginx install layer
- application layer

---

# Layer Caching

Docker reuses unchanged layers to speed builds.

Optimization rule:
- Place stable instructions first
- Frequently changing code later

---

# Base Images

Base image defines application runtime environment.

Examples:

| Runtime      | Image       |
| ------------ | ----------- |
| Python       | python:3.12 |
| Node.js      | node:22     |
| Nginx        | nginx       |
| Alpine Linux | alpine      |
| Ubuntu       | ubuntu      |

---

# Minimal Base Images

Production environments prefer minimal images.

Advantages:
- Smaller size
- Faster pull times
- Reduced vulnerabilities

Examples:
- alpine
- distroless
- slim variants

---

# FROM Instruction

Defines base image.

```dockerfile
FROM python:3.12-slim
```

---

# WORKDIR Instruction

Sets working directory.

```dockerfile
WORKDIR /app
```

---

# COPY Instruction

Copies files from host to image.

```dockerfile
COPY requirements.txt .
```

---

# ADD vs COPY

| Instruction | Usage                         |
| ----------- | ----------------------------- |
| COPY        | Standard file copying         |
| ADD         | Auto extraction + remote URLs |

Production recommendation:
- Prefer `COPY`

---

# RUN Instruction

Executes commands during image build.

```dockerfile
RUN apt update && apt install -y curl
```

---

# CMD Instruction

Defines default runtime command.

```dockerfile
CMD ["python", "app.py"]
```

Important:
- Only one CMD should exist

---

# ENTRYPOINT Instruction

Defines fixed executable.

```dockerfile
ENTRYPOINT ["python"]
```

---

# CMD vs ENTRYPOINT

| CMD               | ENTRYPOINT       |
| ----------------- | ---------------- |
| Default arguments | Fixed executable |
| Easily overridden | Less flexible    |

Production pattern:

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

---

# ENV Instruction

Defines environment variables.

```dockerfile
ENV APP_ENV=production
```

---

# EXPOSE Instruction

Documents listening ports.

```dockerfile
EXPOSE 8000
```

Important:
- Does not publish ports automatically

---

# USER Instruction

Run application as non-root.

```dockerfile
USER appuser
```

Production recommendation:
- Never run applications as root

---

# Create Non-Root User

```dockerfile
RUN useradd -m appuser
USER appuser
```

---

# Multi-Stage Builds

Used to reduce final image size.

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

Advantages:
- Smaller runtime image
- No build tools in production image
- Reduced attack surface

---

# Distroless Images

Contain only:
- Application
- Runtime dependencies

No shell/package manager included.

Advantages:
- Extremely secure
- Minimal footprint

---

# Build Context

Docker sends build context to daemon.

Example:

```bash
docker build .
```

Current directory becomes build context.

Important:
- Large contexts slow builds

---

# .dockerignore

Excludes unnecessary files from build context.

Example:

```text
.git
venv/
node_modules/
__pycache__/
```

Production importance:
- Faster builds
- Smaller context
- Reduced accidental exposure

---

# Image Tagging

```bash
docker build -t myapp:v1 .
```

Best practice:
- Use explicit versions
- Avoid `latest`

---

# Image Inspection

```bash
docker image inspect myapp
```

---

# Image History

```bash
docker history myapp
```

Useful for:
- Layer analysis
- Optimization
- Secret detection

---

# Build Without Cache

```bash
docker build --no-cache .
```

---

# Remove Images

```bash
docker rmi IMAGE_ID
```

---

# Image Optimization Techniques

## Combine RUN Instructions

Bad:

```dockerfile
RUN apt update
RUN apt install -y curl
```

Better:

```dockerfile
RUN apt update && apt install -y curl
```

---

# Remove Package Cache

```dockerfile
RUN apt update && \
    apt install -y curl && \
    rm -rf /var/lib/apt/lists/*
```

---

# Use Slim Images

Bad:

```dockerfile
FROM ubuntu
```

Better:

```dockerfile
FROM python:3.12-slim
```

---

# Security Hardening

## Production Recommendations

- Use non-root users
- Use minimal images
- Remove unnecessary packages
- Avoid storing secrets
- Scan images regularly
- Pin dependency versions
- Use trusted base images

---

# Image Vulnerability Scanning

Popular tools:
- Trivy
- Grype
- Docker Scout
- Snyk

---

# Scan Image Example

```bash
trivy image myapp:v1
```

---

# Secret Exposure Risks

Bad practice:

```dockerfile
ENV AWS_SECRET=xxxxx
```

Never store:
- API keys
- Passwords
- Tokens
- Certificates

inside images.

---

# Immutable Images

Production principle:
- Images should never change after build

Deploy new image versions instead of modifying running containers.

---

# Common Production Patterns

| Pattern              | Purpose              |
| -------------------- | -------------------- |
| Multi-stage builds   | Reduce image size    |
| Distroless runtime   | Improve security     |
| Non-root containers  | Reduce privilege     |
| Minimal dependencies | Lower attack surface |

---

# Common Build Issues

## Large Image Size

Cause:
- Heavy base images
- Uncleaned package cache

---

## Slow Builds

Cause:
- Poor layer ordering
- Large build context

---

## Permission Denied

Cause:
- Wrong USER ownership
- Incorrect file permissions

---

# Troubleshooting Commands

## Inspect Layers

```bash
docker history IMAGE_NAME
```

---

## Open Shell Inside Container

```bash
docker run -it IMAGE_NAME sh
```

---

## View Build Logs

```bash
docker build --progress=plain .
```

---

# Production Dockerfile Example

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

# Important Concepts

## Immutable Infrastructure

Infrastructure replaced, not modified.

---

## Reproducible Builds

Same Dockerfile should generate identical images.

---

## Layer Reusability

Shared layers improve build performance.

---
