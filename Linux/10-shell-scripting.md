
# Shell Scripting in Linux

## What is Shell Scripting?

Shell scripting is the process of writing commands in a script file to automate tasks in Linux.

A shell script is a text file containing:
- Linux commands
- variables
- conditions
- loops
- functions

Most Linux automation uses:
- Bash scripting

Script files usually use:

```bash
.sh
```

extension.

---

# Why Shell Scripting Matters in DevOps

Shell scripting is heavily used in:

- Automation
- CI/CD pipelines
- Server provisioning
- Monitoring
- Backup systems
- Deployment workflows

Examples:
- Automated backups
- Health check scripts
- Log cleanup automation
- Service monitoring
- Infrastructure setup

---

# What is Bash?

Bash (Bourne Again Shell) is the default shell in most Linux distributions.

Check current shell:

```bash
echo $SHELL
```

Common shells:
- bash
- zsh
- sh
- fish

---

# Creating a Shell Script

Create file:

```bash
nano script.sh
```

Example:

```bash
#!/bin/bash

echo "Hello Linux"
```

---

# Shebang (#!)

The first line in a script is called the shebang.

Example:

```bash
#!/bin/bash
```

It tells Linux which interpreter should execute the script.

---

# Making Script Executable

Add executable permission:

```bash
chmod +x script.sh
```

Run script:

```bash
./script.sh
```

---

# Variables in Shell Scripting

Variables store values.

Example:

```bash
#!/bin/bash

name="Zenithra"

echo $name
```

---

# User Input

Accept user input using:

```bash
read
```

Example:

```bash
#!/bin/bash

read -p "Enter your name: " name

echo "Welcome $name"
```

---

# Conditional Statements

## if Statement

Example:

```bash
#!/bin/bash

num=10

if [ $num -gt 5 ]
then
    echo "Number is greater than 5"
fi
```

---

## if-else Statement

Example:

```bash
#!/bin/bash

num=2

if [ $num -gt 5 ]
then
    echo "Greater"
else
    echo "Smaller"
fi
```

---

# Loops in Shell Scripting

## for Loop

Example:

```bash
#!/bin/bash

for i in 1 2 3 4 5
do
    echo $i
done
```

---

## while Loop

Example:

```bash
#!/bin/bash

count=1

while [ $count -le 5 ]
do
    echo $count
    ((count++))
done
```

---

# Functions in Shell Scripting

Functions help organize reusable code.

Example:

```bash
#!/bin/bash

greet() {
    echo "Welcome to Linux"
}

greet
```

---

# Exit Status in Linux

Every command returns an exit status.

| Exit Code | Meaning |
| --------- | ------- |
| 0         | Success |
| Non-zero  | Failure |

Check exit status:

```bash
echo $?
```

---

# Command-Line Arguments

Scripts can accept arguments.

Example:

```bash
#!/bin/bash

echo "First argument: $1"
echo "Second argument: $2"
```

Run:

```bash
./script.sh devops linux
```

---

# Useful Shell Commands

| Command | Purpose            |
| ------- | ------------------ |
| echo    | Display output     |
| read    | Take user input    |
| chmod   | Change permissions |
| grep    | Search text        |
| awk     | Text processing    |
| sed     | Stream editing     |
| cut     | Extract fields     |

---

# Automating Tasks with Scripts

Shell scripts are commonly used for:
- backups
- monitoring
- deployments
- cleanup tasks
- cron jobs

Example backup script:

```bash
#!/bin/bash

tar -czf backup.tar.gz /home/ubuntu
```

---

# Scheduling Scripts with Cron

Cron is used for scheduling tasks.

Edit cron jobs:

```bash
crontab -e
```

Example:

```text
0 2 * * * /home/ubuntu/backup.sh
```

Runs script daily at 2 AM.

---

# Debugging Shell Scripts

## Enable Debug Mode

```bash
bash -x script.sh
```

Useful for:
- troubleshooting
- finding script errors

---

# Important Shell Scripting Commands

```bash
chmod +x
bash
sh
echo
read
grep
awk
sed
cut
crontab
```

---

# Real-World DevOps Relevance

Shell scripting is heavily used in:
- CI/CD pipelines
- Ansible automation
- Docker environments
- Kubernetes administration
- Cloud infrastructure

Examples:
- deployment automation
- server health checks
- log monitoring
- backup scheduling
- infrastructure setup

---

# Common Mistakes

- Running scripts without executable permissions
- Hardcoding sensitive credentials
- Ignoring exit codes
- Poor error handling
- Using unnecessary root privileges

---

# Summary

Shell scripting is a powerful Linux automation tool used for:
- system administration
- DevOps workflows
- monitoring
- deployments
- infrastructure automation

Understanding shell scripting is essential for:
- DevOps engineering
- Linux administration
- Cloud operations
- Automation workflows
