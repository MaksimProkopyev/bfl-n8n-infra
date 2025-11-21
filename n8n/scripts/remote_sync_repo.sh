#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/remote_ssh.sh" bash <<'REMOTE'
set -euo pipefail

BFL_INFRA_WORKDIR="/opt/bfl-n8n-infra"
REPO_URL="https://github.com/MaksimProkopyev/bfl-n8n-infra.git"

# Ensure base directory exists and is writable by current user
if [ ! -d "$BFL_INFRA_WORKDIR" ]; then
  sudo mkdir -p "$BFL_INFRA_WORKDIR"
  sudo chown -R "$USER":"$USER" "$BFL_INFRA_WORKDIR"
fi

cd "$BFL_INFRA_WORKDIR"

if [ -d ".git" ]; then
  # Update existing clone to origin/main
  git fetch origin
  git reset --hard origin/main
else
  # Fresh clone
  git clone "$REPO_URL" .
fi
REMOTE
