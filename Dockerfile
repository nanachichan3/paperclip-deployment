# ── Paperclip Deployment: Official Image + Hermes + Cursor ──────────────────
# Start from the official Paperclip image, add missing tools on top
# Running: Paperclip API (port 3100) + Hermes gateway (port 18790)
# Build:  docker build -t ghcr.io/nanachichan3/paperclip-deployment:latest .
# Push:   docker push ghcr.io/nanachichan3/paperclip-deployment:latest

FROM paperclipai/paperclip:latest

USER root

# ── Extra tools ───────────────────────────────────────────────────────────
# Hermes Agent (Python CLI required by Paperclip's hermes adapter)
RUN pip3 install --break-system-packages hermes-agent || \
    python3 -m pip install --break-system-packages hermes-agent || true

# Cursor CLI (known package names)
RUN npm install --global --omit=dev cursor-ai 2>/dev/null || \
    npm install --global --omit=dev @cursor.com/cli 2>/dev/null || true

# Gemini CLI
RUN pip3 install --break-system-packages google-generativeai 2>/dev/null || true

# OpenClaw / Hermes gateway
RUN npm install --global --omit=dev openclaw@latest || true

USER paperclip

# ── Start Paperclip API ────────────────────────────────────────────────────
EXPOSE 3100 18790
CMD ["paperclip"]
