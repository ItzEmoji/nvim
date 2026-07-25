{ ... }:
{
  vim.utility.motion.flash-nvim = {
    enable = true;

    mappings = {
      # Flash defaults to `s`/`S`, but mini.surround already owns `s` as a
      # normal-mode prefix (sa, sd, sr, sf, sF, sh) and `S` is substitute-line.
      jump = "<leader>j";
      treesitter = "<leader>J";

      # remote and treesitter_search are operator/visual mode only, and toggle
      # is command mode only, so their defaults collide with nothing.
    };
  };
}
