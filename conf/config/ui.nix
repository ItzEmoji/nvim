{ pkgs, lib, ... }:
{
  vim.ui = {
    noice.enable = true;
    colorizer.enable = true;
  };
  vim.visuals.nvim-web-devicons.enable = true;
}
