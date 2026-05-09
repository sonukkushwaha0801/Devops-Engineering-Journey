# Users, Groups & Permissions in Linux

## Introduction

Linux is a multi-user operating system where multiple users can access and use system resources securely.

Linux controls access using:
- Users
- Groups
- Permissions
- Ownership

This security model helps isolate users and protect system resources.

---

# Why This Matters in DevOps

Understanding Linux permissions is critical for:

- SSH access management
- CI/CD deployments
- Docker container permissions
- Server hardening
- Automation scripts
- Production security

Examples:
- Preventing unauthorized access
- Managing deployment users
- Securing configuration files
- Controlling service permissions

---

# Types of Users in Linux

## Root User

The root user has full administrative privileges.

Characteristics:
- UID = 0
- Complete system access
- Can modify any file or process

Example:

```bash
sudo su
```

---

## System Users

System users are created for services and applications.

Examples:
- nginx
- mysql
- nobody

Used for:
- running services securely
- process isolation

Check users:

```bash
cat /etc/passwd
```

---

## Normal Users

Regular users created for human interaction.

Examples:

```bash
/ home / ubuntu
/ home / zenithra
```

Used for:
- login access
- development work
- administration tasks

---

# User Information Files

Linux stores user account information inside:

```bash
/etc/passwd
```

View users:

```bash
cat /etc/passwd
```

Example entry:

```text
thor:x:1001:1001:thor,,,:/home/thor:/usr/bin/bash
```

Breakdown:

| Field         | Description          |
| ------------- | -------------------- |
| thor          | Username             |
| x             | Password placeholder |
| 1001          | UID (User ID)        |
| 1001          | GID (Group ID)       |
| thor,,,       | Comment/User Info    |
| /home/thor    | Home Directory       |
| /usr/bin/bash | Default Shell        |

Actual encrypted passwords are stored in:

```bash
/etc/shadow
```

---

## /etc/group

Stores group information.

Example:

```text
docker:x:999:ubuntu
```

---

## /etc/shadow

Stores encrypted passwords and password aging information.

Restricted access:
- readable only by root

---

# UID and GID

## UID (User ID)

Unique identifier for users.

Examples:
- root → UID 0
- normal users → UID 1000+

Check UID:

```bash
id
```

---

## GID (Group ID)

Unique identifier for groups.

Users can belong to multiple groups.

Example:

```bash
groups ubuntu
```

---

# User Management Commands

## Check Current User

```bash
whoami
```

Displays the currently logged-in user.

---

## Create User (Interactive)

```bash
sudo adduser devops
```

Creates:
- user account
- home directory
- password
- default configuration

Recommended for Ubuntu/Debian systems.

---

## Create User (Non-Interactive)

```bash
sudo useradd devops
```

Creates a user with minimal default configuration.

---

## Create User with Home Directory

```bash
sudo useradd -m devops
```

Creates:
- user account
- home directory

---

## Set Password

```bash
sudo passwd devops
```

Sets or updates the user password.

---

## Delete User

```bash
sudo userdel -r devops
```

Deletes:
- user
- home directory
- mail spool

---

## Change User Shell

```bash
sudo usermod -s /bin/bash devops
```

Changes the default login shell.

---

## Rename User

```bash
sudo usermod -l newname oldname
```

Renames a user account.

---

## Add User to Group

```bash
sudo usermod -aG docker devops
```

Adds user to the docker group.

---

# Group Management Commands

## Create Group

```bash
sudo groupadd developers
```

---

## Delete Group

```bash
sudo groupdel developers
```

---

## Check User Groups

```bash
groups
```

---

# File Ownership in Linux

Every file has:
- owner user
- owner group

Check ownership:

```bash
ls -l
```

Example:

```text
-rw-r--r-- 1 ubuntu developers
```

---

# File Permissions

Linux permissions control:
- who can read
- who can write
- who can execute

Permission types:

| Symbol | Meaning |
| ------ | ------- |
| r      | Read    |
| w      | Write   |
| x      | Execute |

Permission categories:

| Category | Meaning    |
| -------- | ---------- |
| u        | User/Owner |
| g        | Group      |
| o        | Others     |

---

# Permission Representation

Example:

```text
-rwxr-xr--
```

Breakdown:

| Section | Meaning            |
| ------- | ------------------ |
| rwx     | Owner permissions  |
| r-x     | Group permissions  |
| r--     | Others permissions |

---

# chmod Command

Used to change file permissions.

## Symbolic Mode

```bash
chmod u+x script.sh
```

---

## Numeric Mode

```bash
chmod 755 script.sh
```

Meaning:

| Number | Permission |
| ------ | ---------- |
| 7      | rwx        |
| 6      | rw-        |
| 5      | r-x        |
| 4      | r--        |

---

# chown Command

Changes file ownership.

Example:

```bash
sudo chown ubuntu:developers file.txt
```

---

# umask

Defines default permissions for newly created files and directories.

Check current umask:

```bash
umask
```

Example:

```bash
0022
```

---

# sudo in Linux

`sudo` allows users to execute commands with elevated privileges.

Example:

```bash
sudo systemctl restart nginx
```

sudo access is managed through:

```bash
/etc/sudoers
```

Edit safely using:

```bash
visudo
```

---

# Special Permissions

## SUID

Runs executable with file owner's privileges.

Example:

```bash
passwd
```

Check:

```bash
ls -l /usr/bin/passwd
```

---

## SGID

Files execute with group privileges.

Useful for:
- shared directories
- collaborative environments

---

## Sticky Bit

Used mainly on shared directories like:

```bash
/tmp
```

Prevents users from deleting others' files.

Check:

```text
drwxrwxrwt
```

---

# Important Commands

```bash
id
whoami
groups
chmod
chown
usermod
passwd
umask
sudo
visudo
```

---

# Real-World DevOps Relevance

This topic is heavily used in:

- SSH authentication
- CI/CD deployment users
- Docker socket permissions
- Kubernetes node administration
- Secure automation

Examples:
- Permission denied troubleshooting
- SSH key access failures
- Jenkins deployment issues
- Service ownership problems

---

# Common Mistakes

- Giving unnecessary sudo access
- Using chmod 777
- Incorrect ownership on config files
- Running services as root unnecessarily
- Ignoring group-based access control

---

# Summary

Linux security is built around:
- users
- groups
- ownership
- permissions

Understanding this model is essential for:
- DevOps engineering
- Linux administration
- Security hardening
- Cloud infrastructure management
- Production troubleshooting
