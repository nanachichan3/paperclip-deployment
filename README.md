# Paperclip Deployment

Extended Paperclip product image with all AI coding tools pre-installed.

## What's Running (supervisor-managed)

| Service | Port | Description |
|---------|------|-------------|
| **Paperclip API** | 3100 | Production Paperclip control-plane server |
| **Hermes gateway** | 18790 | OpenClaw agent runtime (connected via `openclaw-gateway` adapter) |

## What's Available (pre-installed on `$PATH`, invoke on-demand)

| Tool | Invoke |
|------|--------|
| Claude Code | `docker exec paperclip-agent claude --help` |
| Codex | `docker exec paperclip-agent codex --help` |
| Cursor CLI | `docker exec paperclip-agent cursor --help` |
| Gemini CLI | `docker exec paperclip-agent gemini --help` |
| OpenCode | `docker exec paperclip-agent opencode --help` |
| OpenClaw CLI | `docker exec paperclip-agent openclaw --help` |

## Architecture

Built from `paperclipai/paperclip` (official product) + layered tooling:
- Official Paperclip adapters already included: `cursor-local`, `gemini-local`, `openclaw-gateway`, `claude-local`, `codex-local`, `opencode-local`
- Additional tools installed on top: Cursor CLI, Gemini CLI, OpenClaw/Hermes runtime

## Build & Deploy

```bash
# Local
docker compose build && docker compose up -d

# Coolify — point at this repo's docker-compose.yaml
```

## Data Persistence

All Paperclip data lives in `/paperclip` (backed by `paperclip-data` volume).
**Data is safe** — the volume is preserved across rebuilds.

## Environment

See `.env.example` — key vars: `OPENROUTER_API_KEY`, `DISCORD_BOT_TOKEN`, `DATABASE_URL`, `MEM0_URL`.