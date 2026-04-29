# Gemini CLI wrapper
FROM python:3.12-slim

WORKDIR /app

RUN pip install google-generativeai || true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV GOOGLE_API_KEY=${GOOGLE_API_KEY:-}
ENV WORKSPACE=/workspace

EXPOSE 9003

ENTRYPOINT ["/entrypoint.sh"]