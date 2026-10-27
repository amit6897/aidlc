#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# tests/test-skill-loader.sh
# Basic smoke tests for the AIDLC skill loading and rules merging logic.
# Run from the repo root: bash tests/test-skill-loader.sh
# -----------------------------------------------------------------------------

set -euo pipefail

AIDLC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0
FAIL=0

ok()   { echo "  ✅ $1"; ((PASS++)); }
fail() { echo "  ❌ $1"; ((FAIL++)); }

echo ""
echo "Running AIDLC tests..."
echo ""

# --- Test 1: VERSION file exists
[[ -f "$AIDLC_ROOT/VERSION" ]] && ok "VERSION file exists" || fail "VERSION file missing"

# --- Test 2: install.sh is executable
[[ -x "$AIDLC_ROOT/install.sh" ]] && ok "install.sh is executable" || fail "install.sh not executable"

# --- Test 3: All scaffold skills have a SKILL.md
for skill_dir in "$AIDLC_ROOT/scaffold/ai/skills"/*/; do
  skill=$(basename "$skill_dir")
  if [[ -f "$skill_dir/SKILL.md" ]]; then
    ok "skill '$skill' has SKILL.md"
  else
    fail "skill '$skill' is missing SKILL.md"
  fi
done

# --- Test 4: Each SKILL.md has frontmatter (starts with ---)
for skill_file in "$AIDLC_ROOT/scaffold/ai/skills"/*/SKILL.md; do
  first_line=$(head -1 "$skill_file")
  skill=$(basename "$(dirname "$skill_file")")
  if [[ "$first_line" == "---" ]]; then
    ok "skill '$skill' SKILL.md has valid frontmatter"
  else
    fail "skill '$skill' SKILL.md missing frontmatter delimiter"
  fi
done

# --- Test 5: rules-merger.sh is sourceable
source "$AIDLC_ROOT/core/engine/rules-merger.sh"
result=$(merge_rules "/nonexistent/path")
if [[ -z "$result" ]]; then
  ok "rules-merger returns empty string for missing rules dir"
else
  fail "rules-merger should return empty for missing dir"
fi

# --- Test 6: rules-merger picks up .md files
TMP_RULES=$(mktemp -d)
echo "Always use tabs." > "$TMP_RULES/style.md"
result=$(merge_rules "$TMP_RULES")
if echo "$result" | grep -q "Always use tabs"; then
  ok "rules-merger correctly reads .md files"
else
  fail "rules-merger failed to read .md content"
fi
rm -rf "$TMP_RULES"

echo ""
echo "Results: $PASS passed, $FAIL failed"
echo ""

[[ $FAIL -eq 0 ]] && exit 0 || exit 1
