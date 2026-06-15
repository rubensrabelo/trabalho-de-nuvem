# Camada 1: Construtor (Builder)
FROM python:3.13-alpine AS builder

WORKDIR /app
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt


# Camada 2: Execução (Final)
FROM python:3.13-alpine AS final

WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "wsgi:app"]
