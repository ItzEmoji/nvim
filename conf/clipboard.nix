{ ... }:
{
  # `registers = ""` deliberately leaves vim.options.clipboard empty, so `y`,
  # `p`, and every delete or change stay on Neovim's own registers and cannot
  # clobber the system clipboard. Crossing over is explicit, via the
  # <leader>y / <leader>p binds in config/keybinds.nix.
  #
  # Those binds still need a provider: `"+y` talks to the clipboard through
  # the exact same mechanism `unnamedplus` would have. `package = null` keeps
  # the provider out of nvf's closure, so it has to come from system packages
  # — install wl-clipboard (Wayland, including WSLg) or xclip (X11), and
  # Neovim picks between them based on $WAYLAND_DISPLAY / $DISPLAY. Without
  # one, <leader>y fails with "clipboard: No provider". macOS needs neither,
  # pbcopy is built in.
  vim.clipboard = {
    enable = true;
    registers = "";

    providers = {
      wl-copy = {
        enable = true;
        package = null;
      };
      xclip = {
        enable = true;
        package = null;
      };
    };
  };
}
