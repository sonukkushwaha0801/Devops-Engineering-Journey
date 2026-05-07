````markdown id="gq2q5o"
# Linux Networking

## Introduction

Linux networking is responsible for communication between systems, servers, applications, and cloud infrastructure.

It enables:
- internet connectivity
- server communication
- remote access
- DNS resolution
- application networking

Linux networking is heavily used in:
- cloud computing
- DevOps
- Kubernetes
- Docker
- server administration

---

# Why Networking Matters in DevOps

Understanding networking is critical for:

- Troubleshooting production systems
- Managing cloud infrastructure
- Debugging connectivity issues
- Configuring servers
- Monitoring distributed systems
- Securing applications

Examples:
- SSH connection failures
- DNS issues
- Container communication problems
- Kubernetes networking
- Load balancer troubleshooting

---

# IP Addressing

An IP address identifies a device on a network.

Two main versions:

| Type | Example      |
| ---- | ------------ |
| IPv4 | 192.168.1.10 |
| IPv6 | 2001:db8::1  |

Check IP address:

```bash
ip addr
```

or

```bash
hostname -I
```

---

# Public vs Private IP

## Public IP

Accessible over the internet.

Used for:
- cloud servers
- websites
- public APIs

---

## Private IP

Used inside internal networks.

Common ranges:

```text
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
```

---

# Hostname in Linux

A hostname identifies a system on the network.

Check hostname:

```bash
hostname
```

Detailed information:

```bash
hostnamectl
```

Set hostname:

```bash
sudo hostnamectl set-hostname devops-server
```

---

# Network Interfaces

A network interface connects the system to a network.

Examples:
- eth0
- ens5
- wlan0

View interfaces:

```bash
ip link
```

---

# TCP vs UDP

## TCP (Transmission Control Protocol)

Features:
- reliable
- connection-oriented
- ordered delivery

Examples:
- SSH
- HTTP/HTTPS
- FTP

---

## UDP (User Datagram Protocol)

Features:
- faster
- connectionless
- lower overhead

Examples:
- DNS
- VoIP
- Streaming

---

# Ports in Linux

Ports identify network services running on a system.

Examples:

| Port | Service |
| ---- | ------- |
| 22   | SSH     |
| 80   | HTTP    |
| 443  | HTTPS   |
| 3306 | MySQL   |

Check listening ports:

```bash
ss -tulnp
```

---

# DNS (Domain Name System)

DNS converts domain names into IP addresses.

Example:

```text
google.com → 142.250.x.x
```

Check DNS resolution:

```bash
nslookup google.com
```

or

```bash
dig google.com
```

DNS configuration file:

```bash
/etc/resolv.conf
```

---

# Routing in Linux

Routing determines how network packets travel between networks.

View routing table:

```bash
ip route
```

Example output:

```text
default via 192.168.1.1 dev eth0
```

---

# SSH (Secure Shell)

SSH allows secure remote access to Linux systems.

Basic connection:

```bash
ssh ubuntu@192.168.1.10
```

Common SSH uses:
- server management
- deployments
- automation
- remote administration

SSH configuration file:

```bash
/etc/ssh/sshd_config
```

---

# Network Troubleshooting Commands

## ping

Tests connectivity.

```bash
ping google.com
```

---

## curl

Tests HTTP/HTTPS requests.

```bash
curl https://google.com
```

---

## traceroute

Shows network path.

```bash
traceroute google.com
```

---

## netstat

Displays network statistics.

```bash
netstat -tulnp
```

---

## ss

Modern replacement for netstat.

```bash
ss -tulnp
```

---

## dig

DNS troubleshooting tool.

```bash
dig google.com
```

---

# Firewall Basics

Linux firewalls control incoming and outgoing traffic.

Common firewall tools:
- ufw
- iptables
- firewalld

Check UFW status:

```bash
sudo ufw status
```

Allow SSH:

```bash
sudo ufw allow 22
```

---

# Remote Server Access & Management Tools

Linux administrators and DevOps engineers frequently manage remote servers using GUI, CLI, and cloud-based tools.

---

## Remote Desktop Tools (GUI Access)

Used for graphical remote access.

| Tool                  | Purpose                             |
| --------------------- | ----------------------------------- |
| RDP                   | Windows remote desktop protocol     |
| TeamViewer            | Cross-platform remote access        |
| AnyDesk               | Lightweight remote desktop solution |
| Chrome Remote Desktop | Browser-based remote access         |

---

## SSH Tools (CLI Access)

Used for secure command-line access to servers.

| Tool      | Purpose                                   |
| --------- | ----------------------------------------- |
| PuTTY     | Lightweight SSH client for Windows        |
| OpenSSH   | Standard Linux/Windows SSH implementation |
| Termius   | Modern SSH client with synchronization    |
| MobaXterm | SSH, SFTP, and X11 integrated client      |

---

## File Transfer Tools

Used for secure file transfer between systems.

| Tool      | Purpose                                   |
| --------- | ----------------------------------------- |
| FileZilla | FTP/SFTP file transfer client             |
| WinSCP    | GUI-based secure file transfer            |
| rsync     | Efficient Linux file synchronization tool |

Example:

```bash
rsync -avz project/ ubuntu@server:/backup/
```

---

## Server Management Platforms

Web-based Linux administration tools.

| Tool         | Purpose                                   |
| ------------ | ----------------------------------------- |
| Webmin       | Linux server management dashboard         |
| Cockpit      | Modern Linux web administration interface |
| cPanel / WHM | Hosting server management platform        |

---

## Cloud Management Tools

Used for managing cloud infrastructure remotely.

| Tool             | Purpose                       |
| ---------------- | ----------------------------- |
| AWS CLI          | AWS infrastructure management |
| Azure CLI        | Microsoft Azure management    |
| Google Cloud SDK | Google Cloud administration   |

---

# Important Networking Commands

```bash
ip addr
ip link
ip route
ping
curl
ss
netstat
dig
nslookup
ssh
scp
rsync
```

---

# Real-World DevOps Relevance

Linux networking is heavily used in:
- cloud infrastructure
- Kubernetes
- Docker
- CI/CD systems
- monitoring platforms

Examples:
- SSH troubleshooting
- DNS debugging
- Kubernetes service communication
- API connectivity testing
- Reverse proxy configuration

---

# Common Mistakes

- Blocking SSH with firewall rules
- Incorrect DNS configuration
- Exposing unnecessary ports
- Ignoring routing issues
- Using insecure remote access methods

---

# Summary

Linux networking enables communication between systems, services, and cloud infrastructure.

Understanding networking is essential for:
- DevOps engineering
- Linux administration
- Cloud computing
- Infrastructure troubleshooting
- Production operations
````
