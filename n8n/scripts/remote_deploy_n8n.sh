#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/remote_ssh.sh" bash <<'REMOTE'
set -euo pipefail

N8N_WORKDIR="/opt/n8n"

cd "$N8N_WORKDIR"

if [ -f "./scripts/deploy_n8n.sh" ]; then
  chmod +x ./scripts/deploy_n8n.sh || true
  ./scripts/deploy_n8n.sh
else
  # Fallback: run docker compose directly
  docker compose down || true
  docker compose up -d
fi
REMOTE
