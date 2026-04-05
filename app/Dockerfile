FROM python:3.9-slim

# system dependencies for Postgres connectors
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Keep the container running or run your main script
CMD ["python", "main.py"]