{ ... }:
{
  vim = {
    options = {
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;

      # Share yanks and pastes with the system clipboard.
      clipboard = "unnamedplus";

      # Keep some context visible above and below the cursor.
      scrolloff = 8;

      # Prompt to save instead of failing on :q with unsaved changes.
      confirm = true;
    };

    # Case-insensitive search, unless the pattern contains a capital.
    searchCase = "smart";

    # Persist undo history across sessions, so <leader>su is useful.
    undoFile.enable = true;
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };
    statusline.lualine.enable = true;
  };
}
