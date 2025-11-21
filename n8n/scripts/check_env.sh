#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f ".env" ]; then
  echo "ERROR: .env not found. Copy .env.example → .env and fill values."
  exit 1
fi

echo "[bfl-n8n-infra] Checking important env vars..."
# shellcheck disable=SC1091
source .env

vars=(
  N8N_HOST
  N8N_PORT
  N8N_ENCRYPTION_KEY
  SALES_INTAKE_WEBHOOK_URL
  NURTURE_INTAKE_WEBHOOK_URL
  MCP_SALES_URL
  BFL_CORE_URL
  LEADGEN_CRM_WEBHOOK_URL
  BITRIX_WEBHOOK_URL
  MCP_PROCESS_URL
  ANALYTICS_BACKEND_URL
)

for v in "\${vars[@]}"; do
  val="\${!v-}"
  if [ -z "\${val}" ]; then
    echo "  [MISSING] \$v"
  else
    echo "  [OK]      \$v"
  fi
done
