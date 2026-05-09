
# systemd & Service Management in Linux

## Introduction

`systemd` is the default init system used in most modern Linux distributions.

It is responsible for:
- booting the system
- starting services
- managing processes
- handling logging
- controlling system states

In Linux, the init system is the first userspace process started by the kernel.

```bash
PID 1 = systemd
```

Check:

```bash
ps -p 1
```

---

# Why systemd Matters in DevOps

Understanding systemd is critical for:

- Managing production services
- Troubleshooting applications
- Monitoring servers
- Automating service startup
- Debugging failed deployments
- Managing background processes

Examples:
- Restarting nginx
- Checking Docker service status
- Investigating application failures
- Managing CI/CD runners

---

# What is systemd?

`systemd` is an init system and service manager for Linux.

Responsibilities:
- service management
- boot process management
- logging
- process supervision
- dependency handling

It manages all background services running on the server.

Examples:
- nginx
- docker
- ssh
- mysql

---

# Working with Units

In systemd, resources are managed as units.

Common unit types:

| Unit Type | Purpose             |
| --------- | ------------------- |
| service   | Background services |
| socket    | Socket activation   |
| target    | Group of units      |
| mount     | Filesystem mounts   |
| automount | Automatic mounts    |
| timer     | Scheduled tasks     |

We mainly work with:
- service units

Example:

```bash
nginx.service
docker.service
```

---

# systemd Unit File Locations

systemd loads unit files from multiple locations.

| Directory           | Purpose                       |
| ------------------- | ----------------------------- |
| /etc/systemd/system | Custom/admin-managed units    |
| /run/systemd/system | Runtime-generated units       |
| /lib/systemd/system | Package/vendor-provided units |

Important:
- `/etc/systemd/system` overrides vendor configurations
- Most custom service changes should be placed inside `/etc/systemd/system`

---

# Service Management Commands

## Check Service Status

```bash
sudo systemctl status nginx
```

Displays:
- service state
- logs
- PID
- runtime information

---

## Start Service

```bash
sudo systemctl start nginx
```

Starts the service immediately.

---

## Stop Service

```bash
sudo systemctl stop nginx
```

Stops the running service.

---

## Restart Service

```bash
sudo systemctl restart nginx
```

Stops and starts the service again.

Used after:
- config changes
- deployments
- updates

---

## Reload Service

```bash
sudo systemctl reload nginx
```

Reloads configuration without full restart.

Useful when:
- application supports config reload
- avoiding downtime

---

## Enable Service at Boot

```bash
sudo systemctl enable nginx
```

Starts service automatically during boot.

---

## Disable Service at Boot

```bash
sudo systemctl disable nginx
```

Removes automatic startup.

---

# Viewing All Services

## List Running Services

```bash
systemctl list-units --type=service
```

---

## List Failed Services

```bash
systemctl --failed
```

Useful for troubleshooting.

---

# Example Service Unit File

Example:

```ini
[Unit]
Description=My Application Service

[Service]
ExecStart=/usr/bin/python3 app.py
Restart=always
User=ubuntu

[Install]
WantedBy=multi-user.target
```

Main sections:

| Section   | Purpose                    |
| --------- | -------------------------- |
| [Unit]    | Metadata and dependencies  |
| [Service] | Service execution settings |
| [Install] | Boot/startup configuration |

---

# Editing Services Safely

## Create Override Configuration

```bash
sudo systemctl edit nginx.service
```

Creates a safe override file without modifying original unit files.

Stored in:

```bash
/etc/systemd/system/nginx.service.d/override.conf
```

Benefits:
- safer upgrades
- clean customization
- vendor-safe changes

---

## Edit Full Service File

```bash
sudo systemctl edit --full nginx.service
```

Creates a complete editable copy of the service file.

Use carefully because:
- future package updates may conflict

---

# Applying Configuration Changes

## Reload systemd Configuration

```bash
sudo systemctl daemon-reload
```

Reloads unit files after changes.

Required after:
- editing unit files
- adding new services

---

## Re-execute systemd Process

```bash
sudo systemctl daemon-reexec
```

Re-executes the systemd process without rebooting the server.

Rarely needed in normal administration.

---

# journalctl

`journalctl` is used to view logs managed by systemd.

---

## View Complete Logs

```bash
journalctl
```

---

## View Service Logs

```bash
journalctl -u nginx
```

---

## Follow Live Logs

```bash
journalctl -f
```

---

## View Recent Critical Logs

```bash
journalctl -xe
```

Used for:
- troubleshooting services
- debugging startup failures
- monitoring logs

---

# systemd Targets

Targets are groups of units used to control system states.

Examples:

| Target            | Purpose             |
| ----------------- | ------------------- |
| multi-user.target | Non-GUI server mode |
| graphical.target  | GUI mode            |
| rescue.target     | Recovery mode       |

Check default target:

```bash
systemctl get-default
```

---

# Important Commands

```bash
systemctl
journalctl
systemctl status
systemctl restart
systemctl enable
systemctl disable
daemon-reload
daemon-reexec
```

---

# Real-World DevOps Relevance

systemd is heavily used in:
- cloud servers
- Docker hosts
- Kubernetes nodes
- CI/CD runners
- monitoring systems

Examples:
- restarting failed services
- checking deployment logs
- debugging startup failures
- managing background applications

---

# Common Mistakes

- Editing vendor service files directly
- Forgetting daemon-reload
- Using restart instead of reload unnecessarily
- Ignoring service logs
- Running everything as root

---

# Summary

`systemd` is the core service manager in modern Linux systems.

It handles:
- service lifecycle
- logging
- boot management
- process supervision

Understanding systemd is essential for:
- DevOps engineering
- Linux administration
- Cloud infrastructure
- Production troubleshooting
