
# Process Management in Linux

## Introduction

A process is an instance of a running program.

Linux manages processes using:
- Process IDs (PID)
- Scheduling
- Priorities
- Signals
- Resource allocation

Every running application, command, or service in Linux operates as a process.

Examples:
- nginx
- sshd
- docker
- systemd

---

# Why Process Management Matters in DevOps

Understanding processes is critical for:

- Monitoring servers
- Troubleshooting applications
- Managing services
- Performance optimization
- Debugging high CPU or memory usage
- Automation and scripting

Examples:
- Killing stuck processes
- Restarting failed services
- Identifying resource bottlenecks
- Monitoring production workloads

---

# What is a Process?

A process is a program currently executing in memory.

Each process has:
- PID (Process ID)
- Parent PID (PPID)
- Owner
- State
- Priority
- Memory allocation

Check running processes:

```bash
ps
```

---

# Process Lifecycle

A process generally follows these stages:

1. Created
2. Ready
3. Running
4. Waiting
5. Terminated

Linux manages process execution using the kernel scheduler.

---

# Process States in Linux

| State | Meaning               |
| ----- | --------------------- |
| R     | Running or runnable   |
| S     | Sleeping              |
| D     | Uninterruptible sleep |
| T     | Stopped               |
| Z     | Zombie                |
| X     | Dead                  |

Check process states:

```bash
ps aux
```

Example:

```text
R → Running
S → Sleeping
Z → Zombie
```

---

# PID and PPID

## PID (Process ID)

Unique identifier assigned to each process.

Example:

```bash
echo $$
```

Displays current shell PID.

---

## PPID (Parent Process ID)

Every process is created by another process.

View process hierarchy:

```bash
ps -ef
```

---

# systemd and PID 1

In modern Linux systems:

```bash
PID 1 = systemd
```

`systemd` is the first userspace process started by the kernel.

Responsibilities:
- Starting services
- Managing processes
- Boot management
- Logging integration

Check:

```bash
ps -p 1
```

---

# Viewing Processes

## ps Command

Displays process snapshot.

Examples:

```bash
ps
ps aux
ps -ef
```

---

## top Command

Displays real-time process monitoring.

```bash
top
```

Shows:
- CPU usage
- Memory usage
- Running processes
- System load

---

## htop

Improved interactive process viewer.

```bash
htop
```

Features:
- better UI
- easier navigation
- process tree visualization

---

# Foreground and Background Processes

## Foreground Process

Runs directly in terminal.

Example:

```bash
ping google.com
```

---

## Background Process

Runs independently in background.

Example:

```bash
ping google.com &
```

Check background jobs:

```bash
jobs
```

---

# Managing Processes

## Kill Process

Terminate process using PID.

```bash
kill PID
```

Example:

```bash
kill 1234
```

---

## Force Kill

```bash
kill -9 PID
```

Uses SIGKILL signal.

---

## Kill by Process Name

```bash
pkill nginx
```

---

## Kill All Matching Processes

```bash
killall nginx
```

---

# Process Priorities

Linux uses priorities to schedule processes.

Priority values:
- lower value → higher priority
- higher value → lower priority

---

# nice Command

Starts process with custom priority.

Example:

```bash
nice -n 10 stress
```

---

# renice Command

Changes priority of running process.

Example:

```bash
sudo renice 5 -p 1234
```

---

# Signals in Linux

Signals are used for process communication and control.

Common signals:

| Signal  | Meaning              |
| ------- | -------------------- |
| SIGTERM | Graceful termination |
| SIGKILL | Force kill           |
| SIGSTOP | Pause process        |
| SIGCONT | Continue process     |

View signals:

```bash
kill -l
```

---

# Zombie Processes

A zombie process is:
- terminated
- but still present in process table

Occurs when:
- parent process does not collect child exit status

Check zombies:

```bash
ps aux | grep Z
```

Too many zombie processes may indicate application issues.

---

# Process Monitoring Commands

```bash
ps
top
htop
pidof
pgrep
kill
pkill
killall
jobs
nice
renice
```

---

# Real-World DevOps Relevance

Process management is heavily used in:

- Production troubleshooting
- Service monitoring
- CI/CD systems
- Container orchestration
- Performance tuning

Examples:
- High CPU investigation
- Memory leak debugging
- Restarting failed services
- Killing stuck deployments
- Monitoring container processes

---

# Common Mistakes

- Using kill -9 unnecessarily
- Running heavy processes without monitoring
- Ignoring zombie processes
- Misunderstanding process ownership
- Killing critical system processes

---

# Summary

Linux process management controls:
- program execution
- scheduling
- priorities
- signals
- resource allocation

Understanding processes is essential for:
- DevOps engineering
- Linux administration
- System monitoring
- Production troubleshooting
