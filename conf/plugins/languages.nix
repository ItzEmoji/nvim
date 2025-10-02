{ pkgs, lib, ... }:
{
  
  vim.lsp.enable = true;
  vim.treesitter.enable = true;
  vim.languages = {
    nix.enable = true;
    python.enable = true;
    rust.enable = true;
    go.enable = true;
    css.enable = true;
  };

}
