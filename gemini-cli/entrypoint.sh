#!/bin/bash
# Gemini CLI entrypoint

if command -v gemini &> /dev/null; then
    exec gemini "$@"
else
    echo "Gemini CLI not found."
    exec sleep infinity
fi