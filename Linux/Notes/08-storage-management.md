````markdown id="u9m2kw"
# Storage Management in Linux

## What is Storage Management?

Storage management in Linux involves:
- managing disks
- creating partitions
- mounting filesystems
- monitoring storage usage
- handling logical volumes

Linux treats storage devices as files and manages them through the filesystem hierarchy.

---

# Why Storage Management Matters in DevOps

Understanding storage management is critical for:

- Cloud servers
- Docker volumes
- Kubernetes persistent storage
- Database management
- Backup systems
- Production troubleshooting

Examples:
- Disk full investigation
- Mounting new EBS volumes in AWS
- Managing Docker storage
- Expanding server storage

---

# Storage Devices in Linux

Linux identifies storage devices inside:

```bash
/dev
```

Examples:

```bash
/dev/sda
/dev/xvda
/dev/nvme0n1
```

---

# Block Devices

Storage devices are block devices.

Examples:
- HDD
- SSD
- NVMe disks
- USB drives

View block devices:

```bash
lsblk
```

Example output:

```text
sda
├── sda1
├── sda2
```

---

# Disk Partitions

Partitions divide a disk into separate storage sections.

Benefits:
- better organization
- isolation
- multi-purpose usage

Examples:
- root partition
- swap partition
- data partition

---

# View Disk Information

## lsblk

Displays block devices and partitions.

```bash
lsblk
```

---

## fdisk

Displays partition table information.

```bash
sudo fdisk -l
```

---

## blkid

Displays filesystem UUID information.

```bash
sudo blkid
```

---

# Creating Partitions

Use `fdisk` for partition management.

Open disk:

```bash
sudo fdisk /dev/sdb
```

Common operations inside fdisk:

| Key | Purpose               |
| --- | --------------------- |
| n   | Create partition      |
| d   | Delete partition      |
| p   | Print partition table |
| w   | Save changes          |
| q   | Quit without saving   |

---

# Filesystems in Linux

A filesystem organizes how data is stored on disk.

Common Linux filesystems:

| Filesystem | Usage                     |
| ---------- | ------------------------- |
| ext4       | Default Linux filesystem  |
| xfs        | Enterprise environments   |
| btrfs      | Advanced storage features |
| vfat       | USB compatibility         |

---

# Creating Filesystems

## ext4 Filesystem

```bash
sudo mkfs.ext4 /dev/sdb1
```

---

## xfs Filesystem

```bash
sudo mkfs.xfs /dev/sdb1
```

---

# Mounting Filesystems

Mounting attaches a filesystem to a directory.

Example mount point:

```bash
/mnt/data
```

---

## Mount Filesystem

```bash
sudo mount /dev/sdb1 /mnt/data
```

---

## Unmount Filesystem

```bash
sudo umount /mnt/data
```

---

# Persistent Mounts using /etc/fstab

`/etc/fstab` controls automatic mounts during boot.

Example entry:

```text
UUID=xxxx /mnt/data ext4 defaults 0 0
```

Important:
- incorrect fstab entries may break boot

Check UUID:

```bash
blkid
```

---

# Disk Usage Monitoring

## df Command

Displays filesystem usage.

```bash
df -h
```

Shows:
- total space
- used space
- available space

---

## du Command

Displays directory/file usage.

```bash
du -sh /var/log
```

Useful for:
- finding large files
- troubleshooting disk usage

---

# Swap Space

Swap acts as virtual memory when RAM usage is high.

Check swap:

```bash
swapon --show
```

Memory overview:

```bash
free -h
```

---

# LVM (Logical Volume Manager)

LVM provides flexible storage management.

Advantages:
- resize volumes
- extend storage
- snapshots
- better scalability

Main components:

| Component | Meaning         |
| --------- | --------------- |
| PV        | Physical Volume |
| VG        | Volume Group    |
| LV        | Logical Volume  |

---

# Basic LVM Commands

## Create Physical Volume

```bash
sudo pvcreate /dev/sdb
```

---

## Create Volume Group

```bash
sudo vgcreate vg_data /dev/sdb
```

---

## Create Logical Volume

```bash
sudo lvcreate -L 5G -n lv_data vg_data
```

---

# Important Storage Commands

```bash
lsblk
fdisk
blkid
mount
umount
df -h
du -sh
free -h
swapon
mkfs.ext4
```

---

# Real-World DevOps Relevance

Storage management is heavily used in:
- AWS EBS volumes
- Kubernetes persistent volumes
- Docker storage
- Database servers
- Backup systems

Examples:
- Expanding cloud storage
- Mounting additional disks
- Troubleshooting disk-full servers
- Managing persistent container data

---

# Common Mistakes

- Editing /etc/fstab incorrectly
- Forgetting to mount new disks
- Running out of disk space
- Deleting wrong partitions
- Ignoring filesystem health

---

# Summary

Linux storage management involves:
- disks
- partitions
- filesystems
- mounts
- logical volumes

Understanding storage management is essential for:
- DevOps engineering
- Linux administration
- Cloud infrastructure
- Production operations
````
