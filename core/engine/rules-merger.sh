#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# core/engine/rules-merger.sh
# Reads all *.md files from ai/rules/ in the calling project and
# concatenates them into a single string that is prepended to the
# system prompt of every skill run.
#
# Usage:
#   source "$(dirname "$0")/rules-merger.sh"
#   merged=$(merge_rules "/path/to/project/ai/rules")
# -----------------------------------------------------------------------------

merge_rules() {
  local rules_dir="${1:-ai/rules}"

  if [[ ! -d "$rules_dir" ]]; then
    echo ""
    return
  fi

  local merged=""
  local found=false

  for rule_file in "$rules_dir"/*.md; do
    [[ -f "$rule_file" ]] || continue
    found=true
    local content
    content=$(cat "$rule_file")
    merged="${merged}

## Rule: $(basename "$rule_file" .md)

${content}"
  done

  if [[ "$found" == true ]]; then
    echo "# Project Rules (applied to every skill)
${merged}

---
"
  else
    echo ""
  fi
}
