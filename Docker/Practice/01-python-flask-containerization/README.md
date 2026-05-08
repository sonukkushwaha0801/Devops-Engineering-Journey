# 01-python-flask-containerization

## Overview

Production-oriented Flask application containerized using Docker and Docker Compose.

This project demonstrates:
- Dockerfile creation
- Containerized Python application
- Docker Compose orchestration
- Non-root container execution
- Environment variable management
- Production runtime using Gunicorn

---

# Tech Stack

| Component        | Technology     |
| ---------------- | -------------- |
| Backend          | Flask          |
| Runtime          | Gunicorn       |
| Containerization | Docker         |
| Orchestration    | Docker Compose |

---

# Project Structure

```text
01-python-flask-containerization/
│
├── app/
│   ├── app.py
│   └── requirements.txt
│
├── Dockerfile
├── compose.yaml
├── .dockerignore
└── README.md
```

---

# Application Endpoints

| Endpoint  | Purpose                   |
| --------- | ------------------------- |
| `/`       | Main application response |
| `/health` | Healthcheck endpoint      |

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
cd 01-python-flask-containerization
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
flask-app   Up
```

---

# Access Application

## Main Endpoint

```text
http://localhost:5000
```

---

# Healthcheck Endpoint

```text
http://localhost:5000/health
```

---

# Expected Response

```json
{
  "message": "Docker Flask Application Running",
  "environment": "production"
}
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
docker exec -it flask-app whoami
```

Expected:

```text
appuser
```

---

# Docker Concepts Demonstrated

| Concept               | Status |
| --------------------- | ------ |
| Dockerfile            | ✅      |
| Docker Compose        | ✅      |
| Container Networking  | ✅      |
| Port Mapping          | ✅      |
| Environment Variables | ✅      |
| Non-root User         | ✅      |
| Production Runtime    | ✅      |
| Health Endpoint       | ✅      |

---

# Common Issues

## Port Already In Use

Error:

```text
Bind for 0.0.0.0:5000 failed
```

Solution:
- stop existing process
- or modify port mapping

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
