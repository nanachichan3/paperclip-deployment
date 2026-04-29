# ── Paperclip-Deployment: All-in-One Agent Container ───────────────────────
# ✓ RUNNING:   Paperclip harness API (port 3000) + AIO Sandbox (port 8080)
# ✓ AVAILABLE: Hermes (openclaw), Cursor, Codex, Claude Code, Gemini CLI, OpenCode
#   (pre-installed on $PATH, invoke on-demand via: docker exec paperclip-agent <tool>)

# ── Build stage: compile TypeScript ──────────────────────────────────────
FROM node:22-bullseye AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
COPY packages/harness/package.json ./
COPY packages/harness/prisma ./prisma
COPY packages/harness/tsconfig.json ./
COPY packages/harness/src ./src

RUN npm install --legacy-peer-deps
RUN npx tsc
RUN npx prisma generate --schema=./prisma/schema.prisma

# ── Production stage ──────────────────────────────────────────────────────
FROM node:22-bullseye

WORKDIR /app

RUN apt-get update && apt-get install -y \
    openssl curl wget git ca-certificates gnupg lsb-release \
    python3 python3-pip python3-venv \
    vim nano htop tree jq unzip \
    supervisor logrotate \
    && rm -rf /var/lib/apt/lists/*

# Copy root package files
COPY package.json package-lock.json ./

# Install production deps
RUN npm install --omit=dev --legacy-peer-deps

# Copy built artifacts from builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules ./node_modules

# Copy startup-factory source (for runtime reference)
COPY --from=builder /app/packages/harness/src ./src

# ── Coding CLIs: pre-install but DO NOT start ──────────────────────────────
# Hermes / OpenClaw
RUN npm install -g openclaw@latest

# Claude Code
RUN npm install -g @anthropic-ai/claude-code@latest

# Cursor CLI
RUN npm install -g @cursor.com/cli 2>/dev/null || \
    npm install -g cursor-cli 2>/dev/null || true

# Codex CLI (via pip)
RUN pip3 install --break-system-packages "openai>=1.0.0" "github-toolkit>=0.2.0" 2>/dev/null || true

# Gemini CLI
RUN pip3 install --break-system-packages google-generativeai 2>/dev/null || true
RUN npm install -g @google/generative-ai-cli 2>/dev/null || true

# OpenCode CLI
RUN npm install -g opencode 2>/dev/null || true

# ── Supervisor config ──────────────────────────────────────────────────────
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor /workspace

# Non-root user
RUN groupadd --gid 1001 appgroup && useradd --uid 1001 --gid appgroup appuser
RUN chown -R appuser:appgroup /workspace /app

EXPOSE 3000 8080 18790 9000 9001 9002 9003 9004

USER appuser

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]