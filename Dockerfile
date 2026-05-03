# ── Paperclip Deployment: Official Paperclip + Hermes Agent + Cursor ──────────
# Start from official Paperclip image, layer Hermes Agent and Cursor on top
# Build:  docker build -t ghcr.io/nanachichan3/paperclip-deployment:latest .
# Push:   docker push ghcr.io/nanachichan3/paperclip-deployment:latest

# syntax=docker/dockerfile:1.20
FROM paperclipai/paperclip:latest AS production

USER root

# ── Hermes Agent ( NousResearch — the CLI Paperclip's adapter expects) ───────
# Installs hermes CLI via the official curl | bash installer
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# ── Additional tools ──────────────────────────────────────────────────────
# Cursor CLI
RUN npm install --global --omit=dev cursor-ai 2>/dev/null || \
    npm install --global --omit=dev @cursor.com/cli 2>/dev/null || true

# OpenClaw / Hermes gateway (Python tools)
RUN pip3 install --break-system-packages openclaw 2>/dev/null || true

USER paperclip

EXPOSE 3100 18790

CMD ["paperclip"]
