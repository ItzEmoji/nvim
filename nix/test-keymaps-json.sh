#!/usr/bin/env bash
# Verifies the shape and content of the generated keymaps.json.
set -euo pipefail

json="$(nix build .#keymaps-json --no-link --print-out-paths)"
fail=0

check() {
  local desc="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "ok   - $desc"
  else
    echo "FAIL - $desc (expected '$expected', got '$actual')"
    fail=1
  fi
}

check "schemaVersion is 1" "1" "$(jq -r '.schemaVersion' "$json")"
check "126 keymaps extracted" "126" "$(jq -r '.keymaps | length' "$json")"
check "14 which-key groups extracted" "14" "$(jq -r '.groups | length' "$json")"
check "leader is a single space" " " "$(jq -r '.leader' "$json")"

# Reproducible ordering is what the CI drift check depends on.
check "keymaps are sorted by key" "true" \
  "$(jq -r '[.keymaps[].key] == ([.keymaps[].key] | sort)' "$json")"

# Only the three fields the page renders survive the projection. `jq -S` sorts
# object keys, so the comparison below is against a sorted list.
check "keymaps carry exactly desc, key and mode" '["desc","key","mode"]' \
  "$(jq -cr '[.keymaps[] | keys] | unique | .[0]' "$json")"
check "keymaps carry only one field shape" "1" \
  "$(jq -r '[.keymaps[] | keys] | unique | length' "$json")"

check "every keymap has a non-empty key" "0" \
  "$(jq -r '[.keymaps[] | select(.key == null or .key == "")] | length' "$json")"

# Spot-check a known bind.
check "smart find files desc" "Smart Find Files" \
  "$(jq -r '.keymaps[] | select(.key=="<leader><space>") | .desc' "$json")"
check "smart find files mode" "n" \
  "$(jq -r '.keymaps[] | select(.key=="<leader><space>") | .mode' "$json")"

check "some keymap carries a list-valued mode" "true" \
  "$(jq -r '[.keymaps[] | select((.mode | type) == "array")] | length > 0' "$json")"

# Spot-check a which-key group label, including one carrying the `+` convention.
check "find group label" "Find" "$(jq -r '.groups["<leader>f"]' "$json")"
check "gitsigns group label keeps its raw + prefix" "+Gitsigns" \
  "$(jq -r '.groups["<leader>h"]' "$json")"

exit "$fail"
