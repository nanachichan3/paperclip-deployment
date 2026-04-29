# Paperclip Deployment

Centralized deployment for all agent infrastructure: Paperclip control plane, Hermes agent, AI coding tools (Cursor, Codex, Claude Code, Gemini CLI, OpenCode), and AIO Sandbox.

## Architecture

| Service | Port | Description |
|---------|------|-------------|
| Paperclip API | 3000 | Control plane & governance |
| Hermes Agent | 18790 | OpenClaw CEO/Mojo agent runtime |
| AIO Sandbox | 8080 | Browser/terminal/file sandbox |
| Cursor | 9000 | Cursor IDE (VSCode-based) |
| Codex | 9001 | OpenAI Codex CLI |
| Claude Code | 9002 | Anthropic Claude CLI |
| Gemini CLI | 9003 | Google Gemini CLI |
| OpenCode | 9004 | OpenCode CLI |

## Quick Start

```bash
# Start everything
docker compose up -d

# Start specific service
docker compose up -d sandbox

# View logs
docker compose logs -f sandbox
docker compose logs -f hermes

# Stop all
docker compose down
```

## Service Details

### Paperclip
Control plane for task management, agent coordination, and company governance.
- Docs: https://paperclip.ai
- Env: needs `PAPERCLIP_API_KEY`, `PAPERCLIP_COMPANY_ID`

### Hermes Agent
OpenClaw-powered agent (CEO/CMO/CTO roles) with Discord integration and mem0 memory.
- Docs: https://docs.openclaw.ai
- Env: `OPENROUTER_API_KEY`, `DISCORD_BOT_TOKEN`, `MEM0_URL`

### AIO Sandbox
All-in-one agent sandbox with browser, terminal, file ops, VSCode, Jupyter, and MCP.
- Image: `ghcr.io/agent-infra/sandbox:latest`
- Docs: https://sandbox.agent-infra.com

### Coding CLIs
Wrapper containers for Cursor, Codex, Claude Code, Gemini CLI, OpenCode.
Each mounts the workspace directory for persistent state.

## Environment Variables

Copy `.env.example` to `.env` and fill in your keys:

```bash
PAPERCLIP_API_KEY=pcp_xxx
PAPERCLIP_COMPANY_ID=xxx
OPENROUTER_API_KEY=sk-or-xxx
DISCORD_BOT_TOKEN=xxx
MEM0_URL=http://mem0:5000
MEM0_API_KEY=mem0-self-hosted
HERMES_MODEL=minimax/minimax-m2.7
JWT_SECRET=your-secret-here
```

## Network

All services run on the `coolify` external network. Adjust `docker-compose.yaml` network settings if using a different setup.