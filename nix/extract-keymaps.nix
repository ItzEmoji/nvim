# Extracts every keybinding this configuration sets into a single JSON file,
# along with the which-key group labels that organize them.
#
# Unlike the general option extractor this replaced, no recursive serialization
# or `__type` tagging is needed: keymaps are flat data — strings, booleans, and
# lists of strings — and only the three fields the page renders survive the
# projection below.
{
  lib,
  pkgs,
  # The `config` attrset from `nvf.lib.neovimConfiguration`.
  config,
}:
let
  # `mode` is either a bare mode string or a list of them; both are JSON-safe
  # as-is, and the renderer normalizes them.
  project = k: {
    inherit (k) key mode;
    desc = k.desc or null;
  };

  # Sorted so the derivation output is byte-reproducible: two evaluations that
  # set the same binds must produce identical JSON, or the CI drift check flaps
  # on unrelated changes. `mode` joins the sort key because two binds can share
  # a key while differing in mode, and `lib.sort` is not guaranteed stable.
  #
  # `<` on strings is bytewise, matching the `sort` the test script asserts with.
  sortKey = k: "${k.key} ${toString k.mode}";
  keymaps = lib.sort (a: b: sortKey a < sortKey b) (map project config.vim.keymaps);

  payload = builtins.toJSON {
    schemaVersion = 1;
    leader = config.vim.globals.mapleader or " ";
    groups = config.vim.binds.whichKey.register;
    inherit keymaps;
  };
in
pkgs.runCommand "keymaps.json"
  {
    inherit payload;
    passAsFile = [ "payload" ];
    nativeBuildInputs = [ pkgs.jq ];
  }
  ''
    # Sort keys and pretty-print so the output diffs cleanly.
    jq -S . < "$payloadPath" > "$out"
  ''
