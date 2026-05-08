FROM python:3.12-slim

WORKDIR /automation

RUN apt update && apt install -y \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

COPY Selenium/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY Selenium/ .

CMD ["python3", "bot.py"]
