# Claude Code wrapper
FROM node:22-alpine

WORKDIR /app

# Install Claude CLI
RUN npm install -g @anthropic-ai/claude-code || true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY:-}
ENV CLAUDE_LICENSE_KEY=${CLAUDE_LICENSE_KEY:-}
ENV WORKSPACE=/workspace

EXPOSE 9002

ENTRYPOINT ["/entrypoint.sh"]