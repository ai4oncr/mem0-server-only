FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

ENV PYTHONUNBUFFERED=1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# Install PostgreSQL C library untuk psycopg
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Force reinstall psycopg dengan binary version
RUN pip install --no-cache-dir --force-reinstall psycopg[binary]

# Kembali ke user non-root jika Dockerfile menggunakan user tertentu
# USER node  # Sesuaikan dengan user yang digunakan di Dockerfile asli
