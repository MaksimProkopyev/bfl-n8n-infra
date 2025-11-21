#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/remote_ssh.sh" bash <<'REMOTE'
set -euo pipefail

BFL_INFRA_WORKDIR="/opt/bfl-n8n-infra"
N8N_WORKDIR="/opt/n8n"

# Ensure N8N_WORKDIR exists and owned by current user
if [ ! -d "$N8N_WORKDIR" ]; then
  sudo mkdir -p "$N8N_WORKDIR"
  sudo chown -R "$USER":"$USER" "$N8N_WORKDIR"
fi

cd "$N8N_WORKDIR"

# Sync docker-compose.yml from infra repo with a one-time backup
if [ -f "$BFL_INFRA_WORKDIR/n8n/docker-compose.yml" ]; then
  if [ -f "docker-compose.yml" ] && [ ! -f "docker-compose.yml.bak" ]; then
    cp docker-compose.yml docker-compose.yml.bak
  fi
  cp "$BFL_INFRA_WORKDIR/n8n/docker-compose.yml" ./docker-compose.yml
fi

# Sync scripts from infra repo
if [ -d "$BFL_INFRA_WORKDIR/n8n/scripts" ]; then
  mkdir -p scripts
  cp -r "$BFL_INFRA_WORKDIR/n8n/scripts/." scripts/
fi

# Prepare .env: copy from .env.example if missing
if [ ! -f ".env" ]; then
  if [ -f "$BFL_INFRA_WORKDIR/n8n/.env.example" ]; then
    cp "$BFL_INFRA_WORKDIR/n8n/.env.example" .env
  else
    touch .env
  fi
fi

# Timestamped backup of .env before edits
backup_env=".env.$(date +%Y%m%d-%H%M%S).bak"
cp .env "$backup_env"

ensure_var() {
  local key="$1"
  local value="$2"
  if ! grep -q "^${key}=" .env; then
    printf '%s=%s\n' "$key" "$value" >> .env
  fi
}

# Minimal required values (only if missing)
ensure_var "N8N_HOST" "lunirepoko.beget.app"
ensure_var "N8N_PROTOCOL" "https"
# N8N_PORT is expected to come from .env.example; we only add it if totally missing
ensure_var "N8N_PORT" "5678"

ensure_var "SALES_INTAKE_WEBHOOK_URL" "https://lunirepoko.beget.app/webhook/bfl/sales-intake"
ensure_var "NURTURE_INTAKE_WEBHOOK_URL" "https://lunirepoko.beget.app/webhook/bfl/nurture-intake"

# Placeholders for future integrations: only set if missing
ensure_var "MCP_SALES_URL" "https://example.com/mcp-sales"
ensure_var "MCP_PROCESS_URL" "https://example.com/mcp-process"
ensure_var "BFL_CORE_URL" "https://example.com/bfl-core"
ensure_var "LEADGEN_CRM_WEBHOOK_URL" "https://example.com/leadgen-crm"
ensure_var "BITRIX_WEBHOOK_URL" "https://example.com/bitrix-webhook"
ensure_var "ANALYTICS_BACKEND_URL" "https://example.com/analytics"
REMOTE
