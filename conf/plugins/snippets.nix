{ lib, enabledLanguages, ... }:
let
  inherit (lib.nvim.lua) toLuaObject;
in
{
  # Typing `let` in a Nix buffer and confirming the completion expands to a
  # `let ... in` block; <Tab> then walks the placeholders. The snippets come
  # from friendly-snippets, which is nvf's default provider — snippets/nix.json
  # there also carries mkd (stdenv.mkDerivation), meta, fetchFrom, pkg, with,
  # inherit and hash.
  #
  # Enabling this also registers the [LuaSnip] completion source, and switches
  # on the `luasnip.locally_jumpable` branches of nvf's <Tab>/<S-Tab> mappings,
  # which are emitted as empty blocks while luasnip is off.
  vim.snippets.luasnip.enable = true;

  # friendly-snippets covers some sixty filetypes, and nvf's default loader
  # takes all of them — you would get Python snippets in a .py buffer with
  # python disabled everywhere else. Restricting the loader to the languages
  # from conf/languages.nix keeps snippets in step with the rest of the
  # language layer. An empty language set loads nothing.
  #
  # mkForce rather than an addition: the option is a `lines` type, so a plain
  # definition would append to nvf's unfiltered lazy_load() and load
  # everything anyway. The snipmate loader is carried over by hand, so
  # vim.snippets.luasnip.customSnippets.snipmate keeps working.
  vim.snippets.luasnip.loaders = lib.mkForce ''
    require('luasnip.loaders.from_snipmate').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load({
      include = ${toLuaObject enabledLanguages},
    })
  '';
}
