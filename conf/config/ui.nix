{ pkgs, lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  vim.ui = {
    noice.enable = true;
    colorizer.enable = true;

    # Highlight the other occurrences of whatever word the cursor is on.
    illuminate.enable = true;

    # Folding. Falls back to indent-based folds when no LSP is running,
    # so it works on any file. See the fold options in vim-options.nix.
    nvim-ufo = {
      enable = true;
      setupOpts.provider_selector = mkLuaInline ''
        function(_, _, _)
          return { "treesitter", "indent" }
        end
      '';
    };
  };
  vim.visuals.nvim-web-devicons.enable = true;
}
