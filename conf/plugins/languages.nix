# languages.nix
{ ... }:
{
  
  vim.lsp.enable = true;
  vim.lsp.trouble.enable = true;
  vim.treesitter.enable = true;

  vim.languages = {
    nix.enable = true;
    nix.format.enable = true;
    python.enable = true;
    rust.enable = true;
    go.enable = true;
    css.enable = true;
  };

}
