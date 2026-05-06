# Ansible Realtime Project

## Objective
Automate EC2 lifecycle management on AWS using Ansible.

---

# Tasks

## Task 1 — Create EC2 Instances

Create three (3) EC2 instances on AWS using Ansible loops:

- 2 instances with Ubuntu distribution
- 1 instance with CentOS distribution

### Requirements
- Use Ansible loop for instance creation
- Use `connection: local` on Ansible control node
- Assign public IPs to instances

---

## Task 2 — Configure Passwordless Authentication

Set up passwordless SSH authentication between:

- Ansible control node
- Newly created EC2 instances

### Requirements
- Use SSH key-based authentication
- Ensure Ansible can access all managed nodes without password prompts

---

## Task 3 — Shutdown Ubuntu Instances Only

Automate shutdown of Ubuntu instances using Ansible conditionals.

### Requirements
- Use `when` condition
- Use `gather_facts`
- Shutdown only Ubuntu-based instances
- Do not shutdown CentOS instances

---

# Notes

- AWS region: `ap-south-1`
- EC2 provisioning uses Ansible AWS modules
- Remote management requires inventory configuration
- Passwordless authentication must be configured before running remote playbooks
