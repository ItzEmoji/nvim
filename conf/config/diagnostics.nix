{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  # How long the cursor must sit still before CursorHold fires. Neovim's
  # default is 4s, which is far too long to read as hovering.
  vim.options.updatetime = 500;

  vim.augroups = [ { name = "nvf_hover_diagnostics"; } ];

  vim.autocmds = [
    {
      group = "nvf_hover_diagnostics";
      event = [ "CursorHold" ];
      desc = "Show the diagnostic, or spelling suggestions, under the cursor";
      callback = mkLuaInline ''
        function(_)
          -- Never steal focus, and never stack floats on top of each other.
          if vim.b.nvf_hover_win and vim.api.nvim_win_is_valid(vim.b.nvf_hover_win) then
            return
          end

          -- LSP diagnostics first: they are the more specific signal.
          local _, win = vim.diagnostic.open_float(nil, {
            scope = "cursor",
            focus = false,
            border = "rounded",
            source = true,
          })

          if win then
            vim.b.nvf_hover_win = win
            return
          end

          -- Spelling errors are not diagnostics, so open_float knows nothing
          -- about them. Without this branch, hovering over a word you
          -- misspelled earlier shows nothing at all — the completion menu
          -- only helps while the word is still being typed.
          if not vim.wo.spell then
            return
          end

          local bad, kind = unpack(vim.fn.spellbadword())
          if bad == "" or kind == nil then
            return
          end

          local suggestions = vim.fn.spellsuggest(bad, 5)
          if #suggestions == 0 then
            return
          end

          local lines = { bad .. " -> " }
          for i, suggestion in ipairs(suggestions) do
            table.insert(lines, string.format("  %d. %s", i, suggestion))
          end
          table.insert(lines, "")
          table.insert(lines, "z= to choose, zg to accept the word")

          local _, spell_win = vim.lsp.util.open_floating_preview(lines, "", {
            border = "rounded",
            focusable = false,
          })
          vim.b.nvf_hover_win = spell_win
        end
      '';
    }
  ];
}
