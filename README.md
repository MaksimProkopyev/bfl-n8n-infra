# BFL — n8n Infra

Инфраструктурный репозиторий для n8n в проекте «БФЛ — автономная система бизнеса».

## Структура

- \`n8n/docker-compose.yml\` — docker-стек для n8n.
- \`n8n/.env.example\` — шаблон env-переменных (без секретов).
- \`n8n/scripts/deploy_n8n.sh\` — деплой/перезапуск стека n8n.
- \`n8n/scripts/check_env.sh\` — быстрый чек, что важные env заданы.
- \`n8n/scripts/remote_ssh.sh\` — подключение к удалённому хосту n8n по SSH с использованием переменных окружения.

Боевой \`.env\` лежит рядом с \`docker-compose.yml\` и **никогда не коммитится**.

## SSH-доступ к хосту n8n

Для подключения используйте \`n8n/scripts/remote_ssh.sh\`. Перед запуском убедитесь, что заданы переменные окружения:

- \`BFL_N8N_SSH_HOS\` — хостнейм удалённого сервера.
- \`BFL_N8N_SSH_USER\` — пользователь для подключения.
- \`BFL_N8N_SSH_PORT\` — SSH-порт.
- \`BFL_N8N_SSH_KEY\` — приватный ключ (OpenSSH), значение не выводится в логи.

Примеры команд (только чтение на удалённом сервере):

```bash
cd /workspace/bfl-n8n-infra
chmod +x n8n/scripts/remote_ssh.sh
./n8n/scripts/remote_ssh.sh "hostname; whoami"
./n8n/scripts/remote_ssh.sh "docker ps --format '{{.Names}}' || echo 'docker not found'"
```
