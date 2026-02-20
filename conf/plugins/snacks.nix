{ pkgs, lib, ... }:
{
  vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {

      bigfile.enabled = true;
      dashboard = {
        enabled = true;
        sections = [
          { section = "header"; }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
        ];
      };
      explorer = {
        enabled = true;
        layout = [
          { cycle = false; }
        ];
      };
      indent.enabled = true;
      input.enabled = true;
      notifier = {
        enabled = true;
        timeout = 500;
      };
      picker.enabled = true;
      quickfile.enabled = true;
      scope.enabled = true;
      scroll.enabled = true;
      statuscolumn.enabled = true;
      words.enabled = true;
      styles.enabled = true;
      image.enabled = true;

    };
  };
}
