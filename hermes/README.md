# Hermes agent Docker image
FROM ghcr.io/nanachichan3/hermes-agent-deploy:latest

# Or build from source:
# docker build -t ghcr.io/nanachichan3/hermes-agent:latest ./hermes
#
# Required env vars:
#   OPENROUTER_API_KEY
#   DISCORD_BOT_TOKEN
#   MEM0_URL (optional, defaults to http://mem0:5000)