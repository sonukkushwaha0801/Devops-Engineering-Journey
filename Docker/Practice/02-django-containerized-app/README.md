# 02-django-containerized-app

## Overview

Production-oriented Django application containerized using Docker and Docker Compose.

This project demonstrates:
- Django containerization
- Dockerfile creation
- Docker Compose orchestration
- Production runtime using Gunicorn
- Non-root container execution
- Basic web application deployment

---

# Tech Stack

| Component        | Technology     |
| ---------------- | -------------- |
| Backend          | Django         |
| Runtime          | Gunicorn       |
| Containerization | Docker         |
| Orchestration    | Docker Compose |

---

# Project Structure

```text
02-django-containerized-app/
│
├── app/
│   ├── manage.py
│   ├── requirements.txt
│   │
│   ├── config/
│   └── core/
│
├── Dockerfile
├── compose.yaml
├── .dockerignore
└── README.md
```

---

# Application Endpoint

| Endpoint | Purpose      |
| -------- | ------------ |
| `/`      | Welcome page |

---

# Prerequisites

Install:
- Docker
- Docker Compose

Verify installation:

```bash
docker --version
docker compose version
```

---

# Setup & Run

## Clone Repository

```bash
git clone <REPOSITORY_URL>
```

Move into project directory:

```bash
cd 02-django-containerized-app
```

---

# Build Docker Image

```bash
docker compose build
```

---

# Start Application

```bash
docker compose up -d
```

---

# Verify Running Containers

```bash
docker ps
```

Expected:

```text
django-app   Up
```

---

# Access Application

Open browser:

```text
http://localhost:8000
```

Expected Output:

```text
Welcome to Django Project
```

---

# View Logs

```bash
docker compose logs -f
```

---

# Stop Application

```bash
docker compose down
```

---

# Rebuild Application

```bash
docker compose up --build
```

---

# Verify Non-Root Execution

```bash
docker exec -it django-app whoami
```

Expected:

```text
appuser
```

---

# Docker Concepts Demonstrated

| Concept                  | Status |
| ------------------------ | ------ |
| Dockerfile               | ✅      |
| Docker Compose           | ✅      |
| Gunicorn Runtime         | ✅      |
| Port Mapping             | ✅      |
| Non-root User            | ✅      |
| Containerized Django App | ✅      |

---

# Common Issues

## Port Already In Use

Error:

```text
Bind for 0.0.0.0:8000 failed
```

Solution:
- stop existing process
- or change port mapping in `compose.yaml`

---

# Docker Authentication Error

```text
401 Unauthorized
```

Fix:

```bash
docker logout
docker login
```

---

# Cleanup

Remove containers:

```bash
docker compose down
```

Remove unused Docker resources:

```bash
docker system prune -a
```

---

# 👤 Author

ZENITHRA aka Sonu Kumar Kushwaha

Open for updates and improvements.
In case of any errors or issues, please reach out via LinkedIn profile (link available in GitHub):

🔗 https://github.com/sonukkushwaha0801
