#!/bin/bash
# Codex CLI entrypoint
# Routes to local codex install or remote API

if command -v codex &> /dev/null; then
    exec codex "$@"
else
    echo "Codex CLI not installed. Install from: https://docs.codex.dev"
    echo "Or set OPENAI_API_KEY to use cloud version"
    exec sleep infinity
fi