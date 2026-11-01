{ pkgs, ... }:
{
  # `registers = ""` deliberately leaves vim.options.clipboard empty, so `y`,
  # `p`, and every delete or change stay on Neovim's own registers and cannot
  # clobber the system clipboard. Crossing over is explicit, via the
  # <leader>y / <leader>p binds in config/keybinds.nix.
  #
  # Those binds still need a provider: `"+y` talks to the clipboard through
  # the exact same mechanism `unnamedplus` would have. nvf adds these packages
  # to the editor's PATH, and Neovim picks between them based on
  # $WAYLAND_DISPLAY / $DISPLAY. macOS needs neither, pbcopy is built in.
  vim.clipboard = {
    enable = true;
    registers = "";

    providers = {
      wl-copy.enable = pkgs.stdenv.isLinux;
      xclip.enable = pkgs.stdenv.isLinux;
    };
  };
}
