# Paperclip Deployment

Single container with all agent tools — Paperclip harness, Hermes, AIO Sandbox, and every AI coding CLI pre-installed.

## What's Running

| Service | Port | Description |
|---------|------|-------------|
| **Paperclip API** | 3000 | Agent control-plane server |
| **AIO Sandbox** | 8080 | Browser + terminal + file + MCP + Jupyter |
| Hermes gateway | 18790 | Available (start on demand) |

## What's Available (not running)

All pre-installed on `$PATH`. Invoke via `docker exec paperclip-agent <tool>`:

| Tool | Command |
|------|---------|
| OpenClaw / Hermes | `openclaw gateway start --port 18790` |
| Claude Code | `claude --help` |
| Codex | `codex --help` |
| Cursor CLI | `cursor --help` |
| Gemini CLI | `gemini --help` |
| OpenCode | `opencode --help` |

## Deploy

### Coolify
Point Coolify at this repo's `docker-compose.yaml`.

### Local
```bash
docker compose build && docker compose up -d
```

### Docker Socket Required
The compose mounts `/var/run/docker.sock` so the container can spawn the AIO Sandbox. Without it, only Paperclip runs.

## Build Image
```bash
docker build -t ghcr.io/nanachichan3/paperclip-deployment:latest .
docker push ghcr.io/nanachichan3/paperclip-deployment:latest
```

## Environment

See `.env.example` — requires `PAPERCLIP_API_KEY`, `PAPERCLIP_COMPANY_ID`, `OPENROUTER_API_KEY`, `DISCORD_BOT_TOKEN`, and DB credentials.