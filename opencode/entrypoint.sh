#!/bin/bash
# OpenCode entrypoint

if command -v opencode &> /dev/null; then
    exec opencode "$@"
else
    echo "OpenCode CLI not found."
    exec sleep infinity
fi