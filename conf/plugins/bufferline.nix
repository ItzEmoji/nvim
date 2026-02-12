{ ... }:

{
  vim.tabline.nvimBufferline = {
    enable = true;
    setupOpts = {
      options = {
        mode = "tabs";
        numbers = "none";
        diagnostics = false;
      };
    };
  };
}
