{ ... }:
{
  vim.utility.yanky-nvim = {
    enable = true;

    # "shada" persists the yank ring between sessions, so the clipboard
    # history survives restarts. It requires vim.options.shada to be set.
    setupOpts.ring.storage = "shada";
  };
}
