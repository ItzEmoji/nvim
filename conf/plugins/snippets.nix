{ ... }:
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
}
