{ pkgs, lib, ... }:
{
  vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {

      bigfile.enabled = true;
      dashboard = {
        enabled = true;

        # The header stays snacks' own block-ASCII "NEOVIM". What made the
        # dashboard noisy was the key list: snacks ships eight entries by
        # default (find text, recent files, config, restore session, lazy,
        # quit). Two are enough to start from.
        preset.keys = [
          {
            icon = " ";
            key = "n";
            desc = "New File";
            action = ":ene | startinsert";
          }
          {
            icon = " ";
            key = "f";
            desc = "Find File";
            action = ":lua Snacks.dashboard.pick('files')";
          }
        ];

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
        layout = {
          cycle = false;
        };
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
      image.enabled = true;

    };
  };
}
