# Docker Networking

## Overview

Docker networking enables communication between:

- Container ↔ Container
- Container ↔ Host
- Container ↔ External World

Docker provides isolated virtual networking using Linux networking primitives such as:

- Network namespaces
- Virtual Ethernet (veth)
- Linux bridges
- iptables/NAT

---

# Docker Network Architecture

When Docker starts:

- Docker creates a default bridge network
- Containers receive private IP addresses
- Docker manages internal DNS
- NAT rules are added automatically

---

# Types of Docker Networks

| Driver  | Purpose                            |
| ------- | ---------------------------------- |
| bridge  | Default isolated networking        |
| host    | Uses host network directly         |
| none    | No networking                      |
| overlay | Multi-host communication           |
| macvlan | Assign MAC addresses to containers |

---

# List Docker Networks

```bash
docker network ls
```

Example Output:

```text
NETWORK ID     NAME      DRIVER    SCOPE
xxxxxxx        bridge    bridge    local
xxxxxxx        host      host      local
xxxxxxx        none      null      local
```

---

# Bridge Network

Default Docker network driver.

Features:
- Internal container communication
- NAT-enabled internet access
- Isolated from host network

---

# Run Container on Bridge Network

```bash
docker run -d nginx
```

Inspect container IP:

```bash
docker inspect CONTAINER_ID
```

---

# Inspect Bridge Network

```bash
docker network inspect bridge
```

---

# Custom Bridge Network

Production environments should use custom bridge networks instead of default bridge.

Advantages:
- Better isolation
- Automatic DNS resolution
- Easier service communication

---

# Create Custom Network

```bash
docker network create app-network
```

---

# Run Containers on Custom Network

```bash
docker run -d --name backend --network app-network nginx

docker run -d --name frontend --network app-network nginx
```

---

# Container-to-Container Communication

Containers on same custom network can communicate using container names.

Example:

```bash
curl http://backend
```

Docker internal DNS resolves:
- `backend` → container IP

---

# Connect Running Container to Network

```bash
docker network connect app-network CONTAINER_ID
```

---

# Disconnect Container from Network

```bash
docker network disconnect app-network CONTAINER_ID
```

---

# Host Network

Container shares host networking stack.

No network isolation.

---

# Run Container Using Host Network

```bash
docker run --network host nginx
```

Characteristics:
- High performance
- No port mapping required
- Linux-only production usage

Use cases:
- Monitoring agents
- Performance-sensitive workloads

---

# None Network

Disables all networking.

```bash
docker run --network none nginx
```

Use cases:
- Security-sensitive workloads
- Offline processing jobs

---

# Port Publishing

Expose container ports to host machine.

---

# Publish Port

```bash
docker run -d -p 8080:80 nginx
```

Format:

```text
HOST_PORT:CONTAINER_PORT
```

---

# Bind to Specific Interface

```bash
docker run -p 127.0.0.1:8080:80 nginx
```

---

# Expose Multiple Ports

```bash
docker run -p 8080:80 -p 8443:443 nginx
```

---

# Expose Random Host Port

```bash
docker run -P nginx
```

---

# DNS Resolution Inside Docker

Docker provides embedded DNS server.

Features:
- Automatic container discovery
- Name-based communication
- Internal service resolution

---

# Verify DNS Resolution

```bash
docker exec -it frontend ping backend
```

---

# Overlay Network

Used for:
- Docker Swarm
- Multi-host networking

Allows containers on different hosts to communicate securely.

---

# Create Overlay Network

```bash
docker network create \
  --driver overlay \
  app-overlay
```

---

# Macvlan Network

Assigns real MAC addresses to containers.

Containers appear as physical devices on network.

Use cases:
- Legacy systems
- Network appliances

---

# Network Drivers

## View Supported Drivers

```bash
docker info
```

Common drivers:
- bridge
- host
- overlay
- macvlan
- null

---

# Network Isolation

Custom bridge networks isolate workloads.

Example:
- frontend-network
- backend-network
- monitoring-network

Benefits:
- Reduced attack surface
- Controlled communication
- Better segmentation

---

# Production Networking Practices

## Recommended Practices

- Use custom bridge networks
- Avoid default bridge network
- Limit exposed ports
- Use reverse proxies
- Isolate backend services
- Use internal-only databases
- Segment monitoring traffic

---

# Reverse Proxy Networking

Typical architecture:

```text
Internet
    ↓
Nginx / Traefik
    ↓
Application Containers
    ↓
Database Containers
```

Only reverse proxy should expose public ports.

---

# Inspect Container Networking

```bash
docker inspect CONTAINER_ID
```

---

# Inspect Network Details

```bash
docker network inspect app-network
```

---

# Remove Network

```bash
docker network rm app-network
```

---

# Common Networking Issues

## Port Already Allocated

```text
Bind for 0.0.0.0:80 failed
```

Cause:
- Port already in use

---

## Container Cannot Resolve DNS

Cause:
- Containers not on same network

---

## Connection Refused

Cause:
- Service not listening on expected port

---

# Troubleshooting Commands

## Check Listening Ports

```bash
ss -tulnp
```

---

## Inspect Container IP

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' CONTAINER_ID
```

---

## Test Connectivity

```bash
docker exec -it CONTAINER_ID ping TARGET_CONTAINER
```

---

# Important Production Concepts

## East-West Traffic

Container-to-container communication inside infrastructure.

---

## North-South Traffic

External traffic entering infrastructure.

---

## Service Discovery

Automatic identification of services using DNS.

---
