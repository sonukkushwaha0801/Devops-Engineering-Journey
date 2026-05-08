# Docker Compose

## Overview

Docker Compose is used to define and manage multi-container applications using declarative YAML configuration.

Compose enables:
- Infrastructure reproducibility
- Multi-service orchestration
- Environment standardization
- Simplified deployments

---

# Why Docker Compose

Without Compose:

```bash
docker run ...
docker run ...
docker run ...
```

Managing:
- networks
- ports
- volumes
- dependencies
- environment variables

becomes operationally difficult.

Compose solves this using a single configuration file.

---

# Compose Architecture

Docker Compose works as:
- Client-side orchestration layer
- Wrapper around Docker Engine API

Main file:

```text
compose.yaml
```

---

# Compose File Structure

Basic example:

```yaml
services:
  web:
    image: nginx

  api:
    image: python:3.12
```

---

# Core Compose Components

| Component | Purpose                 |
| --------- | ----------------------- |
| services  | Application containers  |
| networks  | Container communication |
| volumes   | Persistent storage      |
| configs   | External configurations |
| secrets   | Sensitive data          |

---

# Docker Compose Version

Verify installation:

```bash
docker compose version
```

Modern Docker uses:
- `docker compose`
- not `docker-compose`

---

# Basic Compose Lifecycle

```text
compose.yaml
      ↓
docker compose up
      ↓
Multi-container application starts
```

---

# Start Compose Stack

```bash
docker compose up
```

Detached mode:

```bash
docker compose up -d
```

---

# Stop Compose Stack

```bash
docker compose down
```

---

# View Running Services

```bash
docker compose ps
```

---

# View Logs

```bash
docker compose logs
```

Follow logs:

```bash
docker compose logs -f
```

---

# Services

Each service represents a containerized workload.

Example:

```yaml
services:
  nginx:
    image: nginx
```

---

# Container Naming

Compose automatically creates:

```text
project_service_index
```

Example:

```text
myapp-nginx-1
```

---

# Port Mapping

```yaml
services:
  nginx:
    image: nginx
    ports:
      - "8080:80"
```

Format:

```text
HOST_PORT:CONTAINER_PORT
```

---

# Environment Variables

```yaml
services:
  app:
    image: python
    environment:
      APP_ENV: production
      DEBUG: "false"
```

---

# External Environment File

```yaml
env_file:
  - .env
```

---

# Persistent Volumes

```yaml
services:
  postgres:
    image: postgres
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

---

# Bind Mounts

```yaml
volumes:
  - ./app:/usr/src/app
```

---

# Custom Networks

```yaml
services:
  frontend:
    networks:
      - app-network

networks:
  app-network:
```

---

# Service Communication

Compose automatically provides:
- Internal DNS
- Service discovery

Example:

```bash
curl http://backend:5000
```

---

# Service Dependencies

```yaml
depends_on:
  - postgres
```

Important:
- `depends_on` does not guarantee readiness
- Only startup ordering

---

# Healthchecks

Production-grade services should use healthchecks.

---

# Healthcheck Example

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 30s
  timeout: 10s
  retries: 3
```

---

# Restart Policies

```yaml
restart: always
```

Options:
- no
- on-failure
- unless-stopped
- always

---

# Resource Limits

```yaml
deploy:
  resources:
    limits:
      memory: 512M
      cpus: "1"
```

---

# Build Custom Images

```yaml
services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
```

---

# Multi-Container Application Example

```yaml
services:

  frontend:
    image: nginx
    ports:
      - "80:80"

  backend:
    build: ./backend

  postgres:
    image: postgres
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

---

# Compose Profiles

Used for environment segregation.

Example:
- development
- production
- monitoring

---

# Profile Example

```yaml
services:
  prometheus:
    image: prom/prometheus
    profiles:
      - monitoring
```

Run profile:

```bash
docker compose --profile monitoring up
```

---

# Compose Networking Model

Default behavior:
- Compose creates isolated project network
- All services join same network

Benefits:
- Automatic communication
- Isolation
- Simplified DNS

---

# Scaling Services

```bash
docker compose up --scale api=3
```

Use cases:
- APIs
- Workers
- Background processors

---

# Execute Commands Inside Service

```bash
docker compose exec api bash
```

---

# Inspect Compose Configuration

```bash
docker compose config
```

Useful for:
- Validation
- Debugging
- Final rendered output

---

# Compose Build Operations

Build images:

```bash
docker compose build
```

Rebuild without cache:

```bash
docker compose build --no-cache
```

---

# Remove Entire Stack

```bash
docker compose down -v
```

Removes:
- Containers
- Networks
- Volumes

---

# Production Compose Practices

## Recommended Practices

- Use explicit image tags
- Separate environments
- Use `.env` files
- Use healthchecks
- Avoid hardcoded secrets
- Use named volumes
- Use custom networks
- Keep services stateless

---

# Security Best Practices

- Run containers as non-root
- Use read-only mounts
- Limit exposed ports
- Use secrets management
- Isolate internal services

---

# Compose File Organization

Production structure:

```text
project/
│
├── compose.yaml
├── .env
├── Dockerfile
├── configs/
├── scripts/
├── nginx/
└── app/
```

---

# Common Compose Issues

## Port Conflict

```text
Bind for 0.0.0.0:80 failed
```

Cause:
- Port already used on host

---

## Dependency Startup Failure

Cause:
- Service not ready
- Database initialization delay

Solution:
- Healthchecks
- Retry logic

---

## Network Resolution Failure

Cause:
- Different networks
- Wrong service name

---

# Troubleshooting Commands

## View Service Logs

```bash
docker compose logs SERVICE_NAME
```

---

## Inspect Networks

```bash
docker network ls
```

---

## Validate Compose File

```bash
docker compose config
```

---

# Important Production Concepts

## Declarative Infrastructure

Infrastructure defined as code.

---

## Reproducibility

Same environment across:
- development
- testing
- production

---

## Service Isolation

Each service runs independently.

---

# Compose vs Kubernetes

| Feature       | Compose      | Kubernetes |
| ------------- | ------------ | ---------- |
| Complexity    | Low          | High       |
| Scale         | Small/Medium | Large      |
| Orchestration | Basic        | Advanced   |
| Multi-node    | Limited      | Native     |
| Self-healing  | Basic        | Advanced   |

Compose is commonly used for:
- local development
- staging
- small production stacks

---
