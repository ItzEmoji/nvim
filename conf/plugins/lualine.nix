{ lib, pkgs, ...}:
{
  vim.statusline.lualine = {
    enable = true;
    theme = "catppuccin";
    sectionSeparator = { left = ""; right = ""; };
    componentSeparator = { left = ""; right = ""; };

    # Sections mapped from your lualine.lua
    activeSection = {
      a = [''{"mode"}''];
      b = [''{"branch"}, {"diff"}, {"diagnostics"}''];
      c = [];
      x = [''{"filetype"}''];
      y = [];
      z = [''{"location"}''];
    };
  };
}


