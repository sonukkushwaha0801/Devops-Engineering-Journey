# 03-django-selenium-multi-container-app

## Overview

Production-oriented multi-container Docker application using:

- Django web application
- Selenium automation container
- Docker Compose orchestration
- Internal Docker networking

This project demonstrates container-to-container communication using Docker internal DNS and service discovery.

---

# Architecture

```text
Selenium Container
        ↓
http://django-app:8000
        ↓
Django Application Container
```

---

# Tech Stack

| Component | Technology |
|---|---|
| Backend | Django |
| Automation | Selenium |
| Browser | Chromium |
| Runtime | Gunicorn |
| Containerization | Docker |
| Orchestration | Docker Compose |

---

# Project Structure

```text
03-django-selenium-multi-container-app/
│
├── app/
│   ├── manage.py
│   ├── requirements.txt
│   │
│   ├── config/
│   └── core/
│
├── selenium/
│   ├── requirements.txt
│   └── bot.py
│
├── Dockerfile
├── selenium.Dockerfile
├── compose.yaml
├── .dockerignore
└── README.md
```

---

# Features

- Django containerized web application
- Selenium browser automation
- Internal Docker networking
- Multi-container communication
- Docker Compose orchestration
- Headless Chromium execution

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
cd 03-django-selenium-multi-container-app
```

---

# Build Multi-Container Stack

```bash
docker compose build
```

---

# Start Application Stack

```bash
docker compose up
```

---

# Verify Running Containers

```bash
docker ps
```

Expected containers:

```text
django-app
selenium-bot
```

---

# Access Django Application

Open browser:

```text
http://localhost:8000
```

Expected output:

```text
Welcome to Django Project
```

---

# Selenium Automation

The Selenium container automatically:

- launches headless Chromium
- accesses Django container
- retrieves page source
- prints response inside logs

Expected output:

```text
PAGE SOURCE:
Welcome to Django Project
```

---

# Important Docker Networking Concept

Inside Docker containers:

❌ Wrong:

```text
localhost:8000
```

✅ Correct:

```text
django-app:8000
```

Reason:
- Docker Compose provides internal DNS resolution
- services communicate using service names

---

# View Logs

```bash
docker compose logs
```

Follow live logs:

```bash
docker compose logs -f
```

---

# Stop Application Stack

```bash
docker compose down
```

---

# Rebuild Application

```bash
docker compose up --build
```

---

# Verify Django Container

```bash
docker exec -it django-app whoami
```

Expected:

```text
appuser
```

---

# Docker Concepts Demonstrated

| Concept | Status |
|---|---|
| Multi-container Architecture | ✅ |
| Docker Compose | ✅ |
| Internal Docker Networking | ✅ |
| Service Discovery | ✅ |
| Selenium Automation | ✅ |
| Headless Browser Execution | ✅ |
| Container Communication | ✅ |

---

# Common Issues

## selenium.Dockerfile Not Found

Error:

```text
failed to read dockerfile
```

Cause:
- running compose command from wrong directory

Solution:
- run commands from project root directory

---

# Port Already In Use

Error:

```text
Bind for 0.0.0.0:8000 failed
```

Solution:
- stop existing service using port 8000
- or change port mapping

---

# Django Not Reachable

Possible fix:

## `app/config/settings.py`

```python
ALLOWED_HOSTS = ['*']
```

Then rebuild:

```bash
docker compose up --build
```

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
