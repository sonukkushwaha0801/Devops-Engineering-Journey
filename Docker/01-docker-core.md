# Docker Core

## Overview

Docker is a containerization platform used to package applications with their dependencies into isolated, lightweight, and portable runtime environments.

In production environments, Docker enables:

- Consistent deployments
- Environment standardization
- Faster delivery pipelines
- Immutable infrastructure
- Efficient resource utilization

---

# Containerization vs Virtualization

| Feature | Containers | Virtual Machines |
|---|---|---|
| Isolation | Process-level | Hardware-level |
| Boot Time | Seconds | Minutes |
| Resource Usage | Lightweight | Heavy |
| Kernel | Shared Host Kernel | Separate OS |
| Performance | Near-native | Higher overhead |

---

# Docker Architecture

## Core Components

### Docker Client
CLI used to interact with Docker daemon.

### Docker Daemon (`dockerd`)
Responsible for:
- Building images
- Running containers
- Managing networks
- Managing volumes

### Docker Registry
Stores container images.

Examples:
- Docker Hub
- AWS ECR
- GitHub Container Registry

### Docker Objects

- Images
- Containers
- Volumes
- Networks

---

# Docker Lifecycle

```text
Dockerfile
    ↓
Docker Image
    ↓
Docker Container
    ↓
Running Application
```

---

# Docker Installation Verification

```bash
docker version
docker info
docker --version
```

---

# Core Docker Commands

## Image Management

### Pull Image

```bash
docker pull nginx
```

### List Images

```bash
docker images
```

### Remove Image

```bash
docker rmi IMAGE_ID
```

---

# Container Management

## Run Container

```bash
docker run nginx
```

## Run Detached Container

```bash
docker run -d nginx
```

## Port Mapping

```bash
docker run -d -p 8080:80 nginx
```

## Name Container

```bash
docker run -d --name web nginx
```

## List Running Containers

```bash
docker ps
```

## List All Containers

```bash
docker ps -a
```

## Stop Container

```bash
docker stop CONTAINER_ID
```

## Start Container

```bash
docker start CONTAINER_ID
```

## Remove Container

```bash
docker rm CONTAINER_ID
```

---

# Container Logs

```bash
docker logs CONTAINER_ID
```

Follow logs:

```bash
docker logs -f CONTAINER_ID
```

---

# Execute Commands Inside Container

```bash
docker exec -it CONTAINER_ID bash
```

---

# Docker Networking Basics

## Bridge Network

Default Docker network mode.

```bash
docker network ls
```

Inspect network:

```bash
docker network inspect bridge
```

---

# Docker Volumes

Volumes provide persistent storage.

## Create Volume

```bash
docker volume create app-data
```

## Mount Volume

```bash
docker run -v app-data:/data nginx
```

---

# Environment Variables

```bash
docker run -e APP_ENV=production nginx
```

---

# Resource Limits

## CPU Limit

```bash
docker run --cpus="1" nginx
```

## Memory Limit

```bash
docker run -m 512m nginx
```

---

# Restart Policies

## Always Restart

```bash
docker run --restart always nginx
```

---

# Inspect Docker Objects

## Inspect Container

```bash
docker inspect CONTAINER_ID
```

---

# Docker System Cleanup

## Remove Stopped Containers

```bash
docker container prune
```

## Remove Unused Images

```bash
docker image prune
```

## Full Cleanup

```bash
docker system prune -a
```

---

# Production Best Practices

- Use minimal base images
- Avoid running containers as root
- Use explicit image tags
- Keep containers stateless
- Use volumes for persistent data
- Limit CPU and memory usage
- Use health checks
- Avoid storing secrets in images

---

# Common Production Images

| Purpose | Image |
|---|---|
| Web Server | nginx |
| Reverse Proxy | traefik |
| Database | postgres |
| Cache | redis |
| Python Runtime | python |
| Monitoring | prom/prometheus |

---

# Important Concepts

## Immutable Infrastructure

Containers should not be modified manually after deployment.

## Ephemeral Containers

Containers are disposable runtime units.

## Layered Filesystem

Docker images are built using reusable filesystem layers.

---
