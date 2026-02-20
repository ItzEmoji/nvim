{ ... }:
{
  vim = {
    options = {
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
    };
    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };
    statusline.lualine.enable = true;
  };
}
