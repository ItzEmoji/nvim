{ ... }:
{
  vim.utility.motion.precognition = {
    enable = true;

    setupOpts = {
      # Visible by default, which is the whole point: it shows which motion
      # would get you where you are looking. Toggle it off with <leader>up
      # if it turns out to be noisy.
      startVisible = true;

      # Without this the hints shift lines around as they appear.
      showBlankVirtLine = true;
    };
  };
}
