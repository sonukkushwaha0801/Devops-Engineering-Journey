# Linux Filesystem

## What is the Linux Filesystem?

The Linux filesystem is the directory structure used by the operating system to organize and manage files, directories, devices, processes, and system data.

Linux follows a hierarchical directory structure that starts from the root directory:

```bash
/
```

Everything in Linux is treated as a file, including:

- Regular files
- Directories
- Devices
- Processes
- Network sockets

---

# Why Filesystem Knowledge Matters in DevOps

Understanding the Linux filesystem is critical for:

- Troubleshooting servers
- Managing logs
- Configuring services
- Docker and Kubernetes operations
- Backup automation
- Monitoring systems
- Permission management

Examples:

- Nginx configuration → `/etc/nginx`
- Logs → `/var/log`
- User home directories → `/home`
- Temporary files → `/tmp`

---

# Linux Filesystem Hierarchy

![Linux Filesystem](./images/file-system.webp)

Linux uses a standardized directory structure called the Filesystem Hierarchy Standard (FHS).

---

# Root Directory (/)

The root directory is the top-level directory in Linux.

All files and directories exist under:

```bash
/
```

Example:
# Linux Filesystem

## What is the Linux Filesystem?

The Linux filesystem is the directory structure used by the operating system to organize and manage files, directories, devices, processes, and system data.

Linux follows a hierarchical directory structure that starts from the root directory:

```bash
/
```

Everything in Linux is treated as a file, including:

- Regular files
- Directories
- Devices
- Processes
- Network sockets

---

# Why Filesystem Knowledge Matters in DevOps

Understanding the Linux filesystem is critical for:

- Troubleshooting servers
- Managing logs
- Configuring services
- Docker and Kubernetes operations
- Backup automation
- Monitoring systems
- Permission management

Examples:

- Nginx configuration → `/etc/nginx`
- Logs → `/var/log`
- User home directories → `/home`
- Temporary files → `/tmp`

---

# Linux Filesystem Hierarchy

![Linux Filesystem](./images/file-system.webp)

Linux uses a standardized directory structure called the Filesystem Hierarchy Standard (FHS).

---

# Root Directory (/)

The root directory is the top-level directory in Linux.

All files and directories exist under:

```bash
/
```

Example:

```text
/
├── etc
├── home
├── var
├── usr
└── tmp
```

---

# Important Linux Directories

## /etc

Contains system-wide configuration files.

Examples:

- nginx configs
- ssh configs
- passwd files

Common files:

```bash
/etc/passwd
/etc/hosts
/etc/fstab
```

---

## /home

Stores user home directories.

Example:

```bash
/home/ubuntu
/home/zenithra
```

Used for:

- personal files
- scripts
- SSH keys
- development work

---

## /var

Stores variable runtime data.

Important for:

- logs
- cache
- spool files
- databases

Examples:

```bash
/var/log
/var/cache
```

DevOps relevance:

- troubleshooting application logs
- monitoring services

---

## /tmp

Stores temporary files.

Characteristics:

- temporary storage
- may be cleared after reboot
- writable by users

Used by:

- applications
- scripts
- package managers

---

## /usr

Contains user utilities and installed applications.

Examples:

```bash
/usr/bin
/usr/sbin
/usr/local
```

Contains:

- binaries
- libraries
- documentation

---

## /bin

Contains essential user commands.

Examples:

```bash
ls
cp
mv
cat
```

These commands are required for basic system operation.

---

## /sbin

Contains system administration commands.

Examples:

```bash
fdisk
reboot
iptables
```

Mostly used by administrators/root users.

---

## /dev

Contains device files.

Examples:

```bash
/dev/sda
/dev/null
/dev/xvda
```

Linux treats hardware devices as files.

---

## /proc

Virtual filesystem containing process and kernel information.

Examples:

```bash
/proc/cpuinfo
/proc/meminfo
```

Useful for:

- monitoring
- debugging
- performance analysis

---

## /sys

Provides kernel and hardware information.

Used for:

- kernel tuning
- hardware management
- driver interaction

---

# Inodes in Linux

An inode stores metadata about a file.

It contains:

- file permissions
- owner
- timestamps
- file size
- disk location

Check inode number:

```bash
ls -i
```

---

# Hard Link vs Soft Link

## Hard Link

- Direct reference to inode
- Works even if original file is deleted
- Cannot link directories easily

Command:

```bash
ln file1 hardlink
```

---

## Soft Link (Symbolic Link)

- Points to file path
- Breaks if original file is deleted
- Similar to shortcut

Command:

```bash
ln -s file1 softlink
```

---

# Mount Points

Linux attaches filesystems using mount points.

Example:

```bash
/mnt
/media
```

Check mounted filesystems:

```bash
df -h
mount
```

---

# Important Filesystem Commands

```bash
pwd
ls
cd
tree
du -sh
df -h
find
locate
stat
```

---

# Real-World DevOps Relevance

Filesystem knowledge is essential for:

- Log analysis
- Disk troubleshooting
- Docker volume management
- Kubernetes persistent storage
- Backup automation
- Server maintenance

Examples:

- Disk full investigation
- Container storage debugging
- Permission-related failures
- Service configuration troubleshooting

---

# Common Mistakes

- Storing large files in `/tmp`
- Modifying critical files in `/etc` without backup
- Ignoring disk usage monitoring
- Confusing hard links and soft links
- Incorrect file permissions

---

# Summary

The Linux filesystem organizes the operating system using a hierarchical structure.

Understanding directories, file types, inodes, links, and mount points is critical for:

- DevOps engineering
- Linux administration
- Cloud infrastructure
- Troubleshooting production systems

```text
/
├── etc
├── home
├── var
├── usr
└── tmp
```

---

# Important Linux Directories

## /etc

Contains system-wide configuration files.

Examples:

- nginx configs
- ssh configs
- passwd files

Common files:

```bash
/etc/passwd
/etc/hosts
/etc/fstab
```

---

## /home

Stores user home directories.

Example:

```bash
/home/ubuntu
/home/zenithra
```

Used for:

- personal files
- scripts
- SSH keys
- development work

---

## /var

Stores variable runtime data.

Important for:

- logs
- cache
- spool files
- databases

Examples:

```bash
/var/log
/var/cache
```

DevOps relevance:

- troubleshooting application logs
- monitoring services

---

## /tmp

Stores temporary files.

Characteristics:

- temporary storage
- may be cleared after reboot
- writable by users

Used by:

- applications
- scripts
- package managers

---

## /usr

Contains user utilities and installed applications.

Examples:

```bash
/usr/bin
/usr/sbin
/usr/local
```

Contains:

- binaries
- libraries
- documentation

---

## /bin

Contains essential user commands.

Examples:

```bash
ls
cp
mv
cat
```

These commands are required for basic system operation.

---

## /sbin

Contains system administration commands.

Examples:

```bash
fdisk
reboot
iptables
```

Mostly used by administrators/root users.

---

## /dev

Contains device files.

Examples:

```bash
/dev/sda
/dev/null
/dev/xvda
```

Linux treats hardware devices as files.

---

## /proc

Virtual filesystem containing process and kernel information.

Examples:

```bash
/proc/cpuinfo
/proc/meminfo
```

Useful for:

- monitoring
- debugging
- performance analysis

---

## /sys

Provides kernel and hardware information.

Used for:

- kernel tuning
- hardware management
- driver interaction

---

# Inodes in Linux

An inode stores metadata about a file.

It contains:

- file permissions
- owner
- timestamps
- file size
- disk location

Check inode number:

```bash
ls -i
```

---

# Hard Link vs Soft Link

## Hard Link

- Direct reference to inode
- Works even if original file is deleted
- Cannot link directories easily

Command:

```bash
ln file1 hardlink
```

---

## Soft Link (Symbolic Link)

- Points to file path
- Breaks if original file is deleted
- Similar to shortcut

Command:

```bash
ln -s file1 softlink
```

---

# Mount Points

Linux attaches filesystems using mount points.

Example:

```bash
/mnt
/media
```

Check mounted filesystems:

```bash
df -h
mount
```

---

# Important Filesystem Commands

```bash
pwd
ls
cd
tree
du -sh
df -h
find
locate
stat
```

---

# Real-World DevOps Relevance

Filesystem knowledge is essential for:

- Log analysis
- Disk troubleshooting
- Docker volume management
- Kubernetes persistent storage
- Backup automation
- Server maintenance

Examples:

- Disk full investigation
- Container storage debugging
- Permission-related failures
- Service configuration troubleshooting

---

# Common Mistakes

- Storing large files in `/tmp`
- Modifying critical files in `/etc` without backup
- Ignoring disk usage monitoring
- Confusing hard links and soft links
- Incorrect file permissions

---

# Summary

The Linux filesystem organizes the operating system using a hierarchical structure.

Understanding directories, file types, inodes, links, and mount points is critical for:

- DevOps engineering
- Linux administration
- Cloud infrastructure
- Troubleshooting production systems
