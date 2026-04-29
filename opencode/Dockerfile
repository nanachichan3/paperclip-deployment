# OpenCode CLI wrapper
FROM node:22-alpine

WORKDIR /app

RUN npm install -g opencode-cli || true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV OPENCODE_API_KEY=${OPENCODE_API_KEY:-}
ENV WORKSPACE=/workspace

EXPOSE 9004

ENTRYPOINT ["/entrypoint.sh"]