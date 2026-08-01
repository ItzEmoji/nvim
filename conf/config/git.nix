{ ... }:
{
  vim.git = {
    enable = true;

    # Blame for the line the cursor is on, shown at the end of that line and
    # nowhere else. It follows the cursor and disappears with it.
    gitsigns.setupOpts = {
      current_line_blame = true;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
        delay = 300;
      };
      current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>";
    };
  };
}
