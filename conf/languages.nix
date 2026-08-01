{ lib, ... }:
let
  inherit (lib.attrsets) attrNames;

  # The one place to edit. Add a language and you get its LSP, treesitter
  # grammar, formatter and snippets; leave it out and none of that is built.
  #
  #   python.enable = true;
  #   rust.enable = true;
  #   go.enable = true;
  #   css.enable = true;
  #   markdown = { enable = true; extensions.markview-nvim.enable = true; };
  languages = {
    nix.enable = true;
    nix.format.enable = true;
  };

  # nvf defaults every `vim.languages.<lang>.lsp.enable` to `vim.lsp.enable`,
  # and the treesitter and format equivalents to `vim.languages.enable*`.
  # Those globals are plumbing rather than the IDE itself: with them off,
  # `nix.enable = true` buys filetype detection and nothing more. Deriving
  # them from the set above keeps `<lang>.enable = true` a genuine one-liner,
  # while an empty set leaves a plain text editor with no language servers,
  # no grammars and no formatters.
  anyLanguage = languages != { };
in
{
  config = {
    vim.languages = languages // {
      enableTreesitter = anyLanguage;
      enableFormat = anyLanguage;
    };

    vim.lsp.enable = anyLanguage;
    vim.lsp.trouble.enable = anyLanguage;
    vim.treesitter.enable = anyLanguage;

    # Exposed so other modules can scope themselves to the same set instead of
    # repeating the list. See conf/plugins/snippets.nix.
    _module.args.enabledLanguages = attrNames languages;
  };
}
