# Multi-Container Applications

## Overview

Production applications rarely run as a single container.

Modern infrastructure uses multiple isolated services such as:
- Frontend
- Backend API
- Database
- Cache
- Reverse proxy
- Message queue
- Monitoring stack

Docker Compose enables orchestration of these services as a unified application stack.

---

# Multi-Tier Architecture

Typical production architecture:

```text
Client
   ↓
Reverse Proxy
   ↓
Frontend Service
   ↓
Backend API
   ↓
Database
```

Additional components may include:
- Redis
- RabbitMQ
- Prometheus
- Grafana
- ELK Stack

---

# Benefits of Multi-Container Design

| Benefit           | Description                |
| ----------------- | -------------------------- |
| Isolation         | Services run independently |
| Scalability       | Scale specific components  |
| Fault containment | Failure isolation          |
| Reusability       | Independent deployments    |
| Maintainability   | Easier updates             |

---

# Common Service Types

| Service  | Purpose         |
| -------- | --------------- |
| nginx    | Reverse proxy   |
| frontend | UI application  |
| backend  | API service     |
| postgres | Database        |
| redis    | Cache           |
| worker   | Background jobs |

---

# Example Production Stack

```text
Internet
    ↓
Nginx Reverse Proxy
    ↓
Frontend Container
    ↓
Backend API Container
    ↓
PostgreSQL Container
```

---

# Compose-Based Stack

## Example Structure

```text
project/
│
├── compose.yaml
├── frontend/
├── backend/
├── nginx/
├── configs/
└── scripts/
```

---

# Basic Multi-Container Compose Example

```yaml
services:

  frontend:
    build: ./frontend

  backend:
    build: ./backend

  postgres:
    image: postgres

  nginx:
    image: nginx
```

---

# Service Communication

Containers communicate using:
- Internal DNS
- Service names

Example:

```bash
http://backend:8000
```

Docker resolves:
- `backend` → backend container IP

---

# Custom Application Network

Production stacks should use isolated networks.

---

# Network Example

```yaml
networks:
  app-network:
```

Attach services:

```yaml
services:
  backend:
    networks:
      - app-network
```

---

# Reverse Proxy Architecture

Production traffic should flow through reverse proxy.

---

# Example Flow

```text
Client
   ↓
Nginx / Traefik
   ↓
Application Containers
```

Benefits:
- SSL termination
- Load balancing
- Routing
- Security filtering

---

# Nginx Reverse Proxy Example

```yaml
services:

  nginx:
    image: nginx
    ports:
      - "80:80"

  backend:
    build: ./backend
```

---

# Database Integration

Database containers require persistent storage.

---

# PostgreSQL Example

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

# Environment Segregation

Different environments require different configurations.

Examples:
- development
- staging
- production

---

# Environment Variable Example

```yaml
environment:
  APP_ENV: production
```

---

# External Environment Files

```yaml
env_file:
  - .env
```

---

# Dependency Management

Services often depend on:
- databases
- caches
- queues

---

# depends_on Example

```yaml
depends_on:
  - postgres
```

Important:
- Only controls startup order
- Does not guarantee service readiness

---

# Healthchecks

Production services require health monitoring.

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

# Service Scaling

Specific services can scale independently.

---

# Scale Backend APIs

```bash
docker compose up --scale backend=3
```

Use cases:
- APIs
- workers
- background jobs

---

# Stateful vs Stateless Services

| Type      | Example        |
| --------- | -------------- |
| Stateless | APIs, frontend |
| Stateful  | Databases      |

Production principle:
- Keep application containers stateless

---

# Persistent Storage

Databases require persistent volumes.

Example:

```yaml
volumes:
  - postgres-data:/var/lib/postgresql/data
```

---

# Shared Storage Patterns

Use cases:
- Shared uploads
- Shared logs
- Shared artifacts

---

# Logging Architecture

Production logging flow:

```text
Containers
    ↓
Log Collector
    ↓
Centralized Logging System
```

Examples:
- ELK Stack
- Loki
- Fluentd

---

# Monitoring Integration

Production stacks commonly include:
- Prometheus
- Grafana
- cAdvisor

---

# Monitoring Stack Example

```yaml
services:

  prometheus:
    image: prom/prometheus

  grafana:
    image: grafana/grafana
```

---

# Resource Management

Prevent resource exhaustion.

---

# Memory Limits

```yaml
deploy:
  resources:
    limits:
      memory: 512M
```

---

# CPU Limits

```yaml
deploy:
  resources:
    limits:
      cpus: "1"
```

---

# Restart Policies

Production containers should auto-recover.

```yaml
restart: unless-stopped
```

---

# Failure Recovery Concepts

Production systems should handle:
- container crashes
- service restarts
- dependency failures

---

# Service Isolation

Recommended segmentation:

| Network            | Services          |
| ------------------ | ----------------- |
| frontend-network   | nginx, frontend   |
| backend-network    | backend, database |
| monitoring-network | monitoring tools  |

---

# Security Best Practices

## Recommended Practices

- Do not expose databases publicly
- Use internal networks
- Use non-root containers
- Use read-only mounts where possible
- Separate frontend/backend traffic
- Use secrets management

---

# Secrets Handling

Never hardcode:
- passwords
- API keys
- tokens

Use:
- `.env`
- Docker secrets
- external secret managers

---

# Multi-Container Production Example

```yaml
services:

  nginx:
    image: nginx
    ports:
      - "80:80"

  backend:
    build: ./backend
    depends_on:
      - postgres

  postgres:
    image: postgres
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

---

# Common Production Patterns

| Pattern            | Purpose               |
| ------------------ | --------------------- |
| Reverse Proxy      | Traffic routing       |
| Shared Networks    | Service communication |
| Persistent Volumes | Data durability       |
| Stateless APIs     | Horizontal scaling    |
| Healthchecks       | Reliability           |

---

# Common Operational Issues

## Database Startup Delay

Cause:
- DB initialization takes time

Solution:
- Retry logic
- Healthchecks

---

## DNS Resolution Failure

Cause:
- Services on different networks

---

## Port Conflicts

Cause:
- Multiple services exposing same port

---

# Troubleshooting Commands

## View Stack Logs

```bash
docker compose logs
```

---

## Inspect Networks

```bash
docker network inspect NETWORK_NAME
```

---

## Check Running Containers

```bash
docker compose ps
```

---

## Execute Inside Service

```bash
docker compose exec backend bash
```

---

# Production Design Principles

## Loose Coupling

Services should remain independent.

---

## Horizontal Scalability

Scale services individually.

---

## Immutable Deployments

Replace containers instead of modifying them.

---

## Infrastructure as Code

Application stacks defined declaratively.

---

# Real-World Stack Examples

| Stack      | Components                            |
| ---------- | ------------------------------------- |
| Web App    | nginx + frontend + backend + postgres |
| Monitoring | prometheus + grafana                  |
| Logging    | elasticsearch + logstash + kibana     |
| CI/CD      | jenkins + agents                      |

---
