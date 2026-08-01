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
  # on unrelated changes. `mode` joins the sort key so that two binds sharing a
  # key but differing in mode still get a total, self-evident ordering that
  # doesn't depend on their order in `config.vim.keymaps`.
  #
  # `<` on strings is bytewise, matching the `sort` the test script asserts with.
  # The key and mode are joined with a newline (rather than a space) because a
  # space is a legal character in a Neovim lhs and `toString` on a mode list
  # already space-joins, so a space separator can't disambiguate every case.
  # No Neovim lhs contains a raw newline, and `\n` (0x0A) sorts below every
  # printable character, so this doesn't disturb key ordering.
  sortKey = k: "${k.key}\n${lib.concatStringsSep "," (lib.toList k.mode)}";
  keymaps = lib.sort (a: b: sortKey a < sortKey b) (map project config.vim.keymaps);

  payload = builtins.toJSON {
    schemaVersion = 1;
    # No fallback: Neovim's real default leader is `\`, not space, so guessing
    # here would publish a leader that no bind in this config actually uses.
    leader =
      config.vim.globals.mapleader
        or (throw "vim.globals.mapleader is unset; the keybindings page cannot name the leader key");
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
