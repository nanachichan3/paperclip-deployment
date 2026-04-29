#!/bin/bash
# Claude Code entrypoint

if command -v claude &> /dev/null; then
    exec claude "$@"
else
    echo "Claude CLI not found. Install via: npm install -g @anthropic-ai/claude-code"
    exec sleep infinity
fi