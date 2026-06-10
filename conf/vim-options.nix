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
      name = "gruvbox";
      style = "dark";
    };
    statusline.lualine.enable = true;
  };
}
