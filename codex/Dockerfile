# Codex CLI wrapper
# Uses the official codex CLI or open-source alternative

FROM python:3.12-slim

WORKDIR /app

# Install codex or alternative (codex CLI,Continue, etc.)
RUN pip install codexcli || true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV OPENAI_API_KEY=${OPENAI_API_KEY:-}
ENV GITHUB_TOKEN=${GITHUB_TOKEN:-}
ENV WORKSPACE=/workspace

EXPOSE 9001

ENTRYPOINT ["/entrypoint.sh"]