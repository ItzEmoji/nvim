{ pkgs, lib, ... }:
{
  imports = [
    ./conf/config/keybinds.nix
    ./conf/plugins/snacks.nix
    ./conf/config/ui.nix
    ./conf/plugins/languages.nix
    ./conf/plugins/lualine.nix
    ./conf/vim-options.nix
    ./conf/plugins/mini.nix
  ];
  vim = {
    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };
    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
  };

}
