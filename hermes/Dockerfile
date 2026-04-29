FROM node:22-alpine

WORKDIR /app

# Hermes agent depends on OpenClaw runtime
# This uses the existing hermes-agent-deploy setup

# Build args
ARG HERMES_MODEL_ARG=minimax/minimax-m2.7
ARG OPENROUTER_API_KEY

# Install dependencies
RUN npm install -g openclaw@latest 2>/dev/null || true

# Copy Hermes-specific setup
COPY . /app

ENV NODE_ENV=production
ENV HERMES_MODEL=${HERMES_MODEL_ARG}
ENV HERMES_INFERENCE_PROVIDER=openrouter

EXPOSE 18790

CMD ["openclaw", "gateway", "start"]