
# Logging & Monitoring in Linux

## Introduction

Logging and monitoring are critical parts of Linux system administration and DevOps operations.

They help administrators:
- troubleshoot issues
- monitor performance
- analyze failures
- detect resource bottlenecks
- maintain production stability

Linux provides multiple tools for:
- log management
- process monitoring
- CPU analysis
- memory tracking
- disk monitoring

---

# Why Logging & Monitoring Matter in DevOps

Understanding logging and monitoring is essential for:

- Production troubleshooting
- Incident response
- Server monitoring
- Kubernetes node analysis
- Docker debugging
- Performance optimization

Examples:
- High CPU investigation
- Memory leak debugging
- Service failure analysis
- Disk-full troubleshooting
- Network issue investigation

---

# Linux Log Files

Linux stores logs inside:

```bash
/var/log
```

Common log files:

| File              | Purpose              |
| ----------------- | -------------------- |
| /var/log/syslog   | General system logs  |
| /var/log/auth.log | Authentication logs  |
| /var/log/kern.log | Kernel logs          |
| /var/log/dmesg    | Boot/kernel messages |

View logs:

```bash
ls /var/log
```

---

# journalctl & systemd Logs

## What is journalctl?

`journalctl` is the command-line utility used to view and analyze logs managed by `systemd-journald`.

It provides centralized logging for:
- system logs
- kernel logs
- service logs
- boot logs

Modern Linux distributions use `journald` as the primary logging system.

---

# What is systemd-journald?

`systemd-journald` is the logging service managed by systemd.

Responsibilities:
- collecting logs
- storing logs
- indexing logs
- forwarding logs

Logs are stored in:
- binary format
- centralized journal database

Persistent logs are usually stored in:

```bash
/var/log/journal
```

---

# Basic journalctl Commands

## View All Logs

```bash
journalctl
```

Displays complete journal logs.

---

## View Service Logs

```bash
journalctl -u nginx
```

Displays logs only for the specified service.

`-u` means:
- filter logs by systemd unit

Examples:

```bash
journalctl -u docker
journalctl -u ssh
```

---

## Follow Live Logs

```bash
journalctl -f
```

Continuously streams new log entries.

Similar to:

```bash
tail -f
```

---

## Follow Service Logs in Real Time

```bash
journalctl -u nginx -f
```

Useful during:
- deployments
- debugging
- service monitoring

---

# Boot Logs

## View Current Boot Logs

```bash
journalctl -b
```

`-b` filters logs for a specific boot session.

Useful for:
- startup failures
- kernel issues
- boot troubleshooting

---

## View Previous Boot Logs

```bash
journalctl -b -1
```

Shows logs from previous reboot.

---

# Time-Based Filtering

## Logs Since Specific Time

```bash
journalctl --since "1 hour ago"
```

---

## Logs Between Time Range

```bash
journalctl --since "2026-05-01" --until "2026-05-02"
```

Useful for:
- incident investigation
- production debugging

---

# Priority-Based Logs

Linux logs have priority levels.

| Priority | Meaning       |
| -------- | ------------- |
| emerg    | Emergency     |
| alert    | Alert         |
| crit     | Critical      |
| err      | Error         |
| warning  | Warning       |
| info     | Informational |

---

## Show Error Logs Only

```bash
journalctl -p err
```

---

# Kernel Logs

## View Kernel Logs

```bash
journalctl -k
```

Useful for:
- hardware issues
- driver problems
- boot debugging

---

# Persistent Logging

Some systems store logs only in memory.

Enable persistent logging:

```bash
sudo mkdir -p /var/log/journal
sudo systemctl restart systemd-journald
```

Benefits:
- logs survive reboot
- better troubleshooting history

---

# Monitoring CPU Usage

## top

Real-time process and CPU monitoring.

```bash
top
```

Shows:
- CPU usage
- memory usage
- running processes
- system load

---

## htop

Improved interactive monitoring tool.

```bash
htop
```

Features:
- easier navigation
- process tree
- better readability

---

# Monitoring Memory Usage

## free

Displays RAM and swap usage.

```bash
free -h
```

---

## vmstat

Displays:
- memory statistics
- CPU activity
- system performance

```bash
vmstat
```

---

# Monitoring Disk Usage

## df

Displays filesystem disk usage.

```bash
df -h
```

---

## du

Displays directory/file usage.

```bash
du -sh /var/log
```

Useful for:
- locating large files
- troubleshooting storage issues

---

# Monitoring Disk I/O

## iostat

Displays disk input/output statistics.

```bash
iostat
```

Useful for:
- disk bottleneck analysis
- storage performance troubleshooting

---

# Monitoring System Uptime & Load

## uptime

Displays:
- system uptime
- active users
- load averages

```bash
uptime
```

Example:

```text
load average: 0.40, 0.55, 0.60
```

---

# Process Monitoring

## ps

Displays running processes.

```bash
ps aux
```

---

## pidof

Find process ID by name.

```bash
pidof nginx
```

---

## pgrep

Search running processes.

```bash
pgrep nginx
```

---

# Real-Time Log Monitoring

## tail

Monitor logs live.

```bash
tail -f /var/log/syslog
```

---

# Important Monitoring Commands

```bash
journalctl
top
htop
free -h
vmstat
iostat
df -h
du -sh
uptime
ps aux
tail -f
```

---

# Real-World DevOps Relevance

Logging and monitoring are heavily used in:
- cloud infrastructure
- Kubernetes clusters
- Docker hosts
- CI/CD systems
- production servers

Examples:
- debugging failed deployments
- analyzing application crashes
- monitoring server performance
- investigating resource exhaustion

---

# Common Mistakes

- Ignoring logs during troubleshooting
- Not monitoring disk usage
- Forgetting previous boot logs
- Running servers without monitoring tools
- Ignoring system load averages

---

# Summary

Linux logging and monitoring help administrators:
- analyze logs
- monitor resources
- troubleshoot failures
- maintain production stability

Understanding these tools is essential for:
- DevOps engineering
- Linux administration
- Infrastructure monitoring
- Production troubleshooting
