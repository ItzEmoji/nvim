{ ... }:
{
  vim.autocomplete.nvim-cmp = {
    enable = true;
    sourcePlugins = [
      "cmp-path"
    ];
    sources = {
      path = "[path]";
      luasnip = "[luasnip]";
      buffer = "[buffer]";
    };
  };
}
