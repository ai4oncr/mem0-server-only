FROM python:3.12-slim

WORKDIR /app

# Install libpq untuk runtime
RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install requirements (tanpa psycopg dulu)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    # Force reinstall psycopg dengan versi binary (tidak perlu compile)
    pip install --no-cache-dir --force-reinstall "psycopg[binary]"

COPY . .

EXPOSE 8000
ENV PYTHONUNBUFFERED=1
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
