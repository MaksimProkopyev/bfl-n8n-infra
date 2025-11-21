#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "[bfl-n8n-infra] Using docker-compose from: $(pwd)"

if [ ! -f ".env" ]; then
  echo "ERROR: .env not found. Copy n8n/.env.example to n8n/.env and fill real values."
  exit 1
fi

# Бэкап docker-compose.yml и .env на всякий
ts="$(date +%F_%H-%M-%S)"
cp docker-compose.yml "docker-compose.yml.bak_${ts}"
cp .env ".env.bak_${ts}"

echo "[bfl-n8n-infra] Restarting n8n stack..."
docker compose down || docker-compose down || true
docker compose up -d || docker-compose up -d

echo "[bfl-n8n-infra] Done. Current containers:"
docker compose ps || docker-compose ps || true
