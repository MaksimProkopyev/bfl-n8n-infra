#!/usr/bin/env bash
set -euo pipefail

: "${BFL_N8N_SSH_HOS:?BFL_N8N_SSH_HOS is required}"
: "${BFL_N8N_SSH_USER:?BFL_N8N_SSH_USER is required}"
: "${BFL_N8N_SSH_PORT:?BFL_N8N_SSH_PORT is required}"
: "${BFL_N8N_SSH_KEY:?BFL_N8N_SSH_KEY is required}"

tmpkey="$(mktemp)"
chmod 600 "$tmpkey"
printf '%s\n' "$BFL_N8N_SSH_KEY" > "$tmpkey"

SSH_OPTS=(
  -i "$tmpkey"
  -p "$BFL_N8N_SSH_PORT"
  -o StrictHostKeyChecking=accept-new
)

if [ "$#" -gt 0 ]; then
  ssh "${SSH_OPTS[@]}" "$BFL_N8N_SSH_USER@$BFL_N8N_SSH_HOS" "$@"
else
  ssh "${SSH_OPTS[@]}" "$BFL_N8N_SSH_USER@$BFL_N8N_SSH_HOS"
fi

rm -f "$tmpkey"
