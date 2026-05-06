# Task Specification

## Objective
Automate system configuration using Ansible.

## Requirements

1. Ensure `openssh` and `openssl` are upgraded to the latest version
   - Only if already installed
   - If not installed → skip

2. Check whether Docker is installed

3. If Docker is not installed
   - Install Docker on the system
