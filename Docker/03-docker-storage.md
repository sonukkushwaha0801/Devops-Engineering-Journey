# Docker Storage

## Overview

Containers are ephemeral by design.

When a container is removed:
- Internal writable data is lost
- Runtime filesystem changes disappear

Docker storage mechanisms provide:
- Persistent application data
- Shared storage
- Externalized state management

---

# Docker Storage Architecture

Docker uses layered filesystems.

Container filesystem consists of:

```text
Read-Only Image Layers
        +
Writable Container Layer
```

Important:
- Writable layer is temporary
- Persistent data should never rely on container layer

---

# Types of Docker Storage

| Storage Type | Purpose                     |
| ------------ | --------------------------- |
| Volumes      | Persistent managed storage  |
| Bind Mounts  | Host filesystem mapping     |
| tmpfs Mounts | In-memory temporary storage |

---

# Persistent vs Ephemeral Data

| Type       | Example                  |
| ---------- | ------------------------ |
| Persistent | Databases, uploads, logs |
| Ephemeral  | Cache, temp files        |

Production rule:
- Application containers should remain stateless
- Persistent data should live outside containers

---

# Docker Volumes

Volumes are Docker-managed persistent storage.

Advantages:
- Persistent across container deletion
- Better portability
- Easier backup/restore
- Improved isolation

---

# List Volumes

```bash
docker volume ls
```

---

# Create Volume

```bash
docker volume create app-data
```

---

# Inspect Volume

```bash
docker volume inspect app-data
```

---

# Remove Volume

```bash
docker volume rm app-data
```

---

# Mount Volume to Container

```bash
docker run -d \
  -v app-data:/data \
  nginx
```

Format:

```text
VOLUME_NAME:CONTAINER_PATH
```

---

# Named Volumes

Explicitly created and managed.

Example:

```bash
docker volume create postgres-data
```

Production recommendation:
- Always prefer named volumes

---

# Anonymous Volumes

Automatically created by Docker.

Example:

```bash
docker run -v /data nginx
```

Problem:
- Harder lifecycle management
- Difficult cleanup

Avoid in production.

---

# Bind Mounts

Directly map host filesystem into container.

---

# Bind Mount Example

```bash
docker run -d \
  -v /host/logs:/app/logs \
  nginx
```

Format:

```text
HOST_PATH:CONTAINER_PATH
```

---

# Common Bind Mount Use Cases

| Use Case      | Example               |
| ------------- | --------------------- |
| Development   | Live code sync        |
| Configuration | External config files |
| Logs          | Host log collection   |

---

# Bind Mount Risks

- Host filesystem exposure
- Permission conflicts
- Reduced portability

Production recommendation:
- Use cautiously

---

# Read-Only Mounts

Prevent container write access.

```bash
docker run \
  -v /host/config:/app/config:ro \
  nginx
```

---

# tmpfs Mounts

Temporary in-memory filesystem.

Data removed when container stops.

---

# tmpfs Example

```bash
docker run \
  --tmpfs /tmp \
  nginx
```

Use cases:
- Sensitive temporary data
- Performance optimization

---

# Volume Sharing Between Containers

Multiple containers can share same volume.

---

# Shared Volume Example

```bash
docker run -d \
  --name app1 \
  -v shared-data:/data nginx

docker run -d \
  --name app2 \
  -v shared-data:/data nginx
```

---

# Volume Drivers

Docker supports external storage drivers.

Examples:
- NFS
- AWS EBS
- CIFS
- Ceph
- Azure Files

---

# Create Volume Using Driver

```bash
docker volume create \
  --driver local \
  app-data
```

---

# Volume Backup Strategy

Production systems require:
- Scheduled backups
- Snapshot policies
- Disaster recovery procedures

---

# Backup Volume Example

```bash
docker run --rm \
  -v app-data:/data \
  -v $(pwd):/backup \
  ubuntu tar czf /backup/data.tar.gz /data
```

---

# Restore Volume Example

```bash
docker run --rm \
  -v app-data:/data \
  -v $(pwd):/backup \
  ubuntu tar xzf /backup/data.tar.gz -C /
```

---

# Storage Security

Important considerations:
- Least privilege mounts
- Read-only configs
- Encrypt sensitive data
- Restrict host access

---

# File Permission Issues

Common problem:
- Container UID/GID mismatch

Example issue:
- Host file owned by root
- Application container running as non-root

---

# Fix Permission Issues

## Option 1 — Match UID/GID

```bash
docker run -u 1000:1000 nginx
```

## Option 2 — Change Ownership

```bash
chown -R 1000:1000 /host/data
```

---

# Docker Storage Cleanup

## Remove Unused Volumes

```bash
docker volume prune
```

---

# Remove All Unused Objects

```bash
docker system prune -a --volumes
```

---

# Inspect Container Mounts

```bash
docker inspect CONTAINER_ID
```

---

# Production Storage Practices

## Recommended Practices

- Use named volumes
- Avoid anonymous volumes
- Separate application and database storage
- Keep containers stateless
- Use external storage for production databases
- Backup persistent volumes regularly
- Use read-only mounts where possible

---

# Database Storage Example

```bash
docker run -d \
  --name postgres \
  -v postgres-data:/var/lib/postgresql/data \
  postgres
```

---

# Logging Storage Pattern

```text
Application Container
        ↓
Mounted Log Volume
        ↓
Centralized Logging System
```

---

# Common Production Patterns

| Pattern          | Purpose                           |
| ---------------- | --------------------------------- |
| Shared Volumes   | Multi-container data sharing      |
| External Volumes | Persistent infrastructure storage |
| Read-Only Mounts | Security hardening                |
| tmpfs            | Sensitive runtime data            |

---

# Important Concepts

## Stateful Containers

Containers storing persistent runtime data.

Examples:
- Databases
- File storage systems

---

## Stateless Containers

Containers without persistent internal state.

Examples:
- APIs
- Reverse proxies
- Web applications

Production environments prefer:
- Stateless application containers

---

# Common Storage Issues

## Disk Space Exhaustion

Cause:
- Unused images
- Container logs
- Orphaned volumes

---

## Permission Denied

Cause:
- UID/GID mismatch

---

## Data Loss

Cause:
- Using container writable layer instead of persistent storage

---

# Troubleshooting Commands

## Check Disk Usage

```bash
docker system df
```

---

## Inspect Volumes

```bash
docker volume inspect VOLUME_NAME
```

---

## Inspect Mounted Paths

```bash
docker inspect CONTAINER_ID
```

---
