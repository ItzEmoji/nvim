#!/usr/bin/env bash
# Verifies the shape and content of the generated options.json.
set -euo pipefail

json="$(nix build .#options-json --no-link --print-out-paths)"
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
check "64 options extracted" "64" "$(jq -r '.options | length' "$json")"
check "no _module options" "0" "$(jq -r '[.options[] | select(.name | startswith("_module"))] | length' "$json")"
check "options are sorted by name" "true" \
  "$(jq -r '[.options[].name] == ([.options[].name] | sort)' "$json")"
check "every option has a source file" "0" \
  "$(jq -r '[.options[] | select((.sourceFiles | length) == 0)] | length' "$json")"
check "source files are repo-relative" "0" \
  "$(jq -r '[.options[].sourceFiles[] | select(startswith("conf/") | not)] | length' "$json")"

# Spot-check a simple boolean option.
check "noice.enable value" "true" \
  "$(jq -r '.options[] | select(.name=="vim.ui.noice.enable") | .value' "$json")"
check "noice.enable type" "boolean" \
  "$(jq -r '.options[] | select(.name=="vim.ui.noice.enable") | .type' "$json")"
check "noice.enable source" "conf/config/ui.nix" \
  "$(jq -r '.options[] | select(.name=="vim.ui.noice.enable") | .sourceFiles[0]' "$json")"

# Spot-check a string option defined in a different file.
check "flash jump mapping" "<leader>j" \
  "$(jq -r '.options[] | select(.name=="vim.utility.motion.flash-nvim.mappings.jump") | .value' "$json")"

# mkLuaInline must be tagged, not stringified.
check "nvim-ufo provider_selector is tagged lua" "lua" \
  "$(jq -r '.options[] | select(.name=="vim.ui.nvim-ufo.setupOpts") | .value.provider_selector.__type' "$json")"
check "nvim-ufo lua code preserved" "true" \
  "$(jq -r '.options[] | select(.name=="vim.ui.nvim-ufo.setupOpts") | .value.provider_selector.code | contains("treesitter")' "$json")"

# Derivations must be tagged, not inlined as store paths.
check "cmp sourcePlugins contains a tagged derivation" "true" \
  "$(jq -r '[.options[] | select(.name=="vim.autocomplete.nvim-cmp.sourcePlugins") | .value[] | select(type=="object" and .__type=="derivation")] | length > 0' "$json")"

exit "$fail"
