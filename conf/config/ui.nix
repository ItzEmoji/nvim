{ pkgs, lib, ... }:
{
  vim.ui = {
    noice.enable = true;
    colorizer.enable = true;

    # Highlight the other occurrences of whatever word the cursor is on.
    illuminate.enable = true;
  };
  vim.visuals.nvim-web-devicons.enable = true;
}
