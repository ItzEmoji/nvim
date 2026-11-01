{ ... }:
{
  vim.utility.yanky-nvim = {
    enable = true;

    # "shada" persists the yank ring between sessions, so the clipboard
    # history survives restarts. It requires vim.options.shada to be set.
    setupOpts.ring.storage = "shada";

    # Left on, this reads the system clipboard on every focus change to pull
    # outside copies into the ring. Only <leader>y / <leader>p touch the clipboard.
    setupOpts.system_clipboard.sync_with_ring = false;
  };
}
