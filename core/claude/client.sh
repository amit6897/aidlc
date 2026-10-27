#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# core/claude/client.sh
# Low-level wrapper around the Anthropic Messages API.
# Called by skill-runner.sh — not meant to be invoked directly.
#
# Usage:
#   source "$(dirname "$0")/client.sh"
#   claude_call "$system_prompt" "$user_prompt" "$model" "$max_tokens"
# -----------------------------------------------------------------------------

ANTHROPIC_API_URL="https://api.anthropic.com/v1/messages"
ANTHROPIC_API_VERSION="2023-06-01"

claude_call() {
  local system_prompt="$1"
  local user_prompt="$2"
  local model="${3:-claude-sonnet-5-5}"
  local max_tokens="${4:-4096}"

  if [[ -z "$ANTHROPIC_API_KEY" ]]; then
    echo "[aidlc error] ANTHROPIC_API_KEY is not set. Export it before running skills." >&2
    exit 1
  fi

  # Escape strings for JSON
  local escaped_system
  local escaped_user
  escaped_system=$(printf '%s' "$system_prompt" | python3 -c "import json,sys; print(json.dumps(sys.stdin.read()))")
  escaped_user=$(printf '%s'   "$user_prompt"   | python3 -c "import json,sys; print(json.dumps(sys.stdin.read()))")

  local payload
  payload=$(cat <<EOF
{
  "model": "$model",
  "max_tokens": $max_tokens,
  "system": $escaped_system,
  "messages": [
    { "role": "user", "content": $escaped_user }
  ]
}
EOF
)

  local response
  response=$(curl -s -X POST "$ANTHROPIC_API_URL" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: $ANTHROPIC_API_VERSION" \
    -H "content-type: application/json" \
    -d "$payload")

  # Check for API error
  local error_msg
  error_msg=$(echo "$response" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('error',{}).get('message',''))" 2>/dev/null)
  if [[ -n "$error_msg" ]]; then
    echo "[aidlc error] Claude API error: $error_msg" >&2
    exit 1
  fi

  # Extract and print the text response
  echo "$response" | python3 -c "
import json, sys
d = json.load(sys.stdin)
content = d.get('content', [])
for block in content:
    if block.get('type') == 'text':
        print(block['text'])
"
}
