{ lib, pkgs, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  vim.autocomplete.nvim-cmp = {
    enable = true;

    # nvf pins cmp-buffer, cmp-path, cmp-treesitter, cmp-nvim-lsp and
    # cmp-luasnip itself; anything beyond that comes from nixpkgs.
    # cmp-spell would be the natural companion to vim.spellcheck, but nixpkgs
    # marks it unfree, and pulling it in would force allowUnfree on every
    # consumer of this flake.
    sourcePlugins = [
      pkgs.vimPlugins.cmp-nvim-lsp-signature-help
    ];

    # buffer and path are not decoration. nvf's `sources` default lists them,
    # but a default is dropped as soon as any module defines the option, and
    # the LSP module does exactly that. Without these entries the menu is left
    # with nothing but nvim_lsp and treesitter.
    sources = {
      path = "[Path]";
      buffer = "[Buffer]";

      # Parameter hints for the call being typed.
      nvim_lsp_signature_help = "[Signature]";
    };

    # nvf's `mappings` options take a single key each, so <Tab>/<S-Tab> cannot
    # simply grow a second binding. Adding to setupOpts.mapping instead, which
    # merges with the table nvf builds from those options. `cmp` is a local in
    # the generated setup block, so it is in scope here.
    setupOpts.mapping = {
      "<C-j>" = mkLuaInline "cmp.mapping.select_next_item()";
      "<C-k>" = mkLuaInline "cmp.mapping.select_prev_item()";
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
