{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  # Typing `sould` offers `should` in the completion menu, tagged [Spell].
  #
  # The obvious plugin for this, cmp-spell, is marked unfree in nixpkgs, and
  # depending on it would force allowUnfree on every consumer of this flake.
  # The source is small enough to carry directly: it is a `complete` callback
  # over vim.fn.spellsuggest, which draws on the same Nix-provided
  # dictionaries vim.spellcheck already installs.
  vim.autocomplete.nvim-cmp.sources.spell = "[Spell]";

  vim.augroups = [ { name = "nvf_cmp_spell"; } ];

  vim.autocmds = [
    {
      group = "nvf_cmp_spell";
      event = [ "InsertEnter" ];
      desc = "Register the spellsuggest completion source";
      callback = mkLuaInline ''
        function(_)
          -- Deferred for the same reason as the nvim_lsp registration: on
          -- InsertEnter the lazy loader has not finished setting cmp up yet.
          vim.schedule(function()
            local ok, cmp = pcall(require, "cmp")
            if not ok or vim.g.nvf_cmp_spell_registered then
              return
            end
            vim.g.nvf_cmp_spell_registered = true

            cmp.register_source("spell", {
              -- Only ever offer corrections where spellchecking is on, which
              -- vim.spellcheck already scopes away from code buffers.
              is_available = function()
                return vim.wo.spell
              end,

              -- No trigger characters: this fires on ordinary word input.
              get_trigger_characters = function()
                return {}
              end,

              get_keyword_pattern = function()
                return [[\k\+]]
              end,

              complete = function(_, params, callback)
                local word = string.sub(
                  params.context.cursor_before_line,
                  params.offset
                )

                -- Below four characters the suggestions are mostly noise, and
                -- every short word in the buffer would churn the menu.
                if #word < 4 then
                  return callback({ items = {}, isIncomplete = true })
                end

                local items = {}
                for _, suggestion in ipairs(vim.fn.spellsuggest(word, 8)) do
                  -- spellsuggest happily returns the input itself when the
                  -- word is already correct; that is not a correction.
                  if suggestion ~= word then
                    table.insert(items, {
                      label = suggestion,
                      kind = cmp.lsp.CompletionItemKind.Text,
                    })
                  end
                end

                -- isIncomplete, so the list is recomputed as the word grows
                -- rather than being cached against the first few letters.
                callback({ items = items, isIncomplete = true })
              end,
            })
          end)
        end
      '';
    }
  ];
}
