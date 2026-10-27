#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# core/engine/skill-runner.sh
# The heart of AIDLC. Loads a skill, merges project rules, injects
# runtime inputs, and calls the Claude API.
#
# Usage (called by install.sh entrypoint in target project):
#   skill-runner.sh <skill-name> [--<param> <value> ...]
#
# Example:
#   skill-runner.sh implement --requirement "Add UserService with CRUD"
#   skill-runner.sh review-code --file src/UserService.java
# -----------------------------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AIDLC_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$SCRIPT_DIR/rules-merger.sh"
source "$AIDLC_ROOT/core/claude/client.sh"

# ---------- helpers ----------------------------------------------------------

usage() {
  echo "Usage: aidlc run <skill-name> [--<param> <value> ...]"
  echo ""
  echo "Available skills (in ai/skills/):"
  for d in ai/skills/*/; do
    [[ -d "$d" ]] && echo "  - $(basename "$d")"
  done
  exit 1
}

parse_frontmatter() {
  local skill_file="$1"
  local key="$2"
  # Extract YAML frontmatter value for a given key
  awk "/^---$/{found++; next} found==1{print}" "$skill_file" \
    | grep "^${key}:" \
    | sed "s/^${key}:\s*//"
}

parse_prompt_body() {
  local skill_file="$1"
  # Everything after the second --- delimiter
  awk "/^---$/{count++; if(count==2){found=1; next}} found{print}" "$skill_file"
}

inject_inputs() {
  local template="$1"
  shift
  local result="$template"

  # Inject each --key value pair into {{key}} placeholders
  while [[ $# -gt 0 ]]; do
    local key="${1#--}"   # strip leading --
    local value="${2:-}"
    result="${result//\{\{$key\}\}/$value}"
    shift 2
  done

  echo "$result"
}

# ---------- main -------------------------------------------------------------

SKILL_NAME="${1:-}"
[[ -z "$SKILL_NAME" ]] && usage
shift

AI_DIR="${AI_DIR:-ai}"
SKILL_FILE="$AI_DIR/skills/$SKILL_NAME/SKILL.md"

if [[ ! -f "$SKILL_FILE" ]]; then
  echo "[aidlc error] Skill '$SKILL_NAME' not found at $SKILL_FILE" >&2
  echo "Run 'aidlc list' to see available skills." >&2
  exit 1
fi

echo "[aidlc] Running skill: $SKILL_NAME"
echo "[aidlc] Loading rules..."

# 1. Merge project rules into a system preamble
rules_preamble=$(merge_rules "$AI_DIR/rules")

# 2. Parse skill frontmatter
model=$(parse_frontmatter "$SKILL_FILE" "model")
model="${model:-claude-sonnet-5-5}"
max_tokens=$(parse_frontmatter "$SKILL_FILE" "max_tokens")
max_tokens="${max_tokens:-4096}"

# 3. Parse skill prompt body and inject runtime inputs
raw_prompt=$(parse_prompt_body "$SKILL_FILE")
user_prompt=$(inject_inputs "$raw_prompt" "$@")

# 4. Build final system prompt = rules + any skill-level system context
system_prompt="${rules_preamble}You are an expert software engineer. Follow the rules and context above."

echo "[aidlc] Calling Claude ($model)..."
echo "---"

# 5. Call Claude
claude_call "$system_prompt" "$user_prompt" "$model" "$max_tokens"

echo "---"
echo "[aidlc] Done."
