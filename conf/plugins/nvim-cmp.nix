{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  vim.autocomplete.nvim-cmp = {
    enable = true;
    sourcePlugins = [
      "cmp-path"
    ];
    sources = {
      path = "[path]";
      buffer = "[buffer]";
    };
  };

  vim.augroups = [ { name = "nvf_cmp_lsp"; } ];

  # cmp-nvim-lsp never registers the `nvim_lsp` source directly: its whole
  # after/plugin file is `require('cmp_nvim_lsp').setup()`, and setup() only
  # creates an InsertEnter autocmd. nvim-cmp is itself lazy-loaded on
  # InsertEnter and pulls cmp-nvim-lsp in from there, so that autocmd is born
  # too late to run for the InsertEnter that created it. Result: the first
  # insert session of every session has no LSP completion, and any session
  # where the server attaches after you start typing has none either.
  #
  # Re-running the registration pass ourselves fixes both. It is idempotent —
  # cmp_nvim_lsp keeps a client -> source map and skips clients it already has.
  vim.autocmds = [
    {
      group = "nvf_cmp_lsp";
      event = [
        "InsertEnter"
        "LspAttach"
      ];
      desc = "Register the nvim_lsp completion source for attached clients";
      callback = mkLuaInline ''
        function(_)
          -- Deferred, because on InsertEnter the lazy loader has not finished
          -- putting cmp-nvim-lsp on the runtimepath yet.
          vim.schedule(function()
            local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if ok and cmp_nvim_lsp._on_insert_enter then
              cmp_nvim_lsp._on_insert_enter()
            end
          end)
        end
      '';
    }
  ];
}
