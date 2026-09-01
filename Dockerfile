FROM python:3.12-slim

WORKDIR /app

# 1. Install PostgreSQL C library SEBELUM pip install
#    Agar psycopg bisa menemukan libpq saat diinstall dari requirements.txt
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libpq5 \
        gcc \
        libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Copy dan install requirements (psycopg akan sukses karena libpq sudah ada)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copy source code
COPY . .

EXPOSE 8000

ENV PYTHONUNBUFFERED=1

# 4. CMD selalu jadi instruksi terakhir
# Catatan: --reload hanya untuk development, hapus untuk production
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
