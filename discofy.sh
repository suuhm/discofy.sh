#!/bin/bash

# ------------------------------------
# - discofy.sh v0.1 - (c) 2025 suuhm -
# -     Terminal notifier tool       -
# ------------------------------------

# Use external DISCORD_WEBHOOK_URL if set, otherwise use default
if [ -z "$DISCORD_WEBHOOK_URL" ]; then
  DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1234567890987654321"
fi

# Default message format
FORMAT="plain"

if [[ "$1" == "--code" ]]; then
  FORMAT="code"
  shift
elif [[ "$1" == "--plain" ]]; then
  FORMAT="plain"
  shift
fi

# Read input: from stdin or from arguments
if [ ! -t 0 ]; then
  MESSAGE="$(cat)"
else
  MESSAGE="$*"
fi

if [ -z "$MESSAGE" ]; then
  echo "⚠️ No message provided."
  exit 1
fi

# Format as code block if requested
if [[ "$FORMAT" == "code" ]]; then
  MESSAGE=$'```\n'"$MESSAGE"$'\n```'
fi

# Send message to Discord using jq-safe JSON
curl -s -X POST "$DISCORD_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg content "$MESSAGE" '{content: $content}')" > /dev/null

echo "✅ Message sent in format: $FORMAT"

exit 0;
