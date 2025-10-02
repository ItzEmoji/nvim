{ lib, pkgs, ...}:

{
  vim.tabline.bufferline = {
    enable = true;
    setupOpts = {
      options = {
        mode = "tabs";
      };
    };
  };
}
