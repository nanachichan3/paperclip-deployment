# ── Paperclip Deployment: Build from Paperclip monorepo + Hermes Agent ────────
# syntax=docker/dockerfile:1.20

FROM node:lts-trixie-slim AS base
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates gosu curl gh git python3 python3-pip \
  && rm -rf /var/lib/apt/lists/* \
  && corepack enable \
  && usermod -u $USER_UID --non-unique node \
  && groupmod -g $USER_GID --non-unique node \
  && usermod -g $USER_GID -d /paperclip node

# Clone the Paperclip monorepo for build
FROM base AS build
WORKDIR /build
RUN git clone --depth 1 https://github.com/paperclipai/paperclip .

# Install deps and build Paperclip
RUN corepack enable && pnpm install --frozen-lockfile
RUN pnpm build

# Production image
FROM base AS production
WORKDIR /app
COPY --chown=node:node --from=build /build/server/dist /app/server/dist
COPY --chown=node:node --from=build /build/ui/dist /app/ui/dist
COPY --chown=node:node --from=build /build/package.json /app/package.json
COPY --chown=node:node --from=build /build/pnpm-lock.yaml /app/pnpm-lock.yaml
COPY --chown=node:node --from=build /build/pnpm-workspace.yaml /app/pnpm-workspace.yaml
COPY --chown=node:node --from=build /build/.npmrc /app/.npmrc
COPY --chown=node:node --from=build /build/cli /app/cli
COPY --chown=node:node --from=build /build/server /app/server
COPY --chown=node:node --from=build /build/ui /app/ui
COPY --chown=node:node --from=build /build/packages /app/packages
COPY --chown=node:node --from=build /build/patches /app/patches

# Install Hermes Agent (NousResearch) — provides the `hermes` CLI
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Cursor CLI
RUN npm install --global --omit=dev cursor-ai 2>/dev/null || \
    npm install --global --omit=dev @cursor.com/cli 2>/dev/null || true

# Supervisor
RUN apt-get update \
  && apt-get install -y --no-install-recommends openssh-client jq supervisor logrotate \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /paperclip \
  && chown node:node /paperclip

COPY --from=build /build/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV NODE_ENV=production \
  HOME=/paperclip \
  HOST=0.0.0.0 \
  PORT=3100 \
  SERVE_UI=true \
  PAPERCLIP_HOME=/paperclip \
  PAPERCLIP_INSTANCE_ID=default \
  PAPERCLIP_CONFIG=/paperclip/instances/default/config.json \
  PAPERCLIP_DEPLOYMENT_MODE=authenticated \
  PAPERCLIP_DEPLOYMENT_EXPOSURE=private \
  HERMES_GATEWAY_PORT=18790

EXPOSE 3100 18790
ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
