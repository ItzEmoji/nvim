---
sidebar_position: 2
title: Language Support
---

# Language Support

Language servers, formatters and treesitter grammars are installed and configured by
Nix. There is no Mason and no runtime package manager — everything is pinned in
`flake.lock`.

The exact set of enabled languages, and the options controlling them, lives in
[`conf/languages.nix`](https://github.com/ItzEmoji/nvim/blob/main/conf/languages.nix).

## What's enabled today

`conf/languages.nix` currently enables exactly one language:

```nix
languages = {
  nix.enable = true;
  nix.format.enable = true;
};
```

That single entry is enough to turn on LSP, treesitter and formatting globally too:
enabling any language flips `vim.lsp.enable`, `vim.treesitter.enable` and
`vim.languages.enableTreesitter`/`enableFormat` on for the whole config. With the
`languages` set empty, none of that plumbing is built — you'd get a plain text editor
with no language servers, no grammars and no formatters.

## Adding a language

Add an entry to the `languages` set in `conf/languages.nix`:

```nix
languages = {
  nix.enable = true;
  nix.format.enable = true;
  rust.enable = true;
};
```

`nvf` defaults each language's `lsp.enable`, treesitter and format flags to the global
switches above, so `rust.enable = true` alone is normally enough to get its LSP,
grammar and formatter. Set `rust.lsp.enable`, `rust.treesitter.enable` or
`rust.format.enable` explicitly only if you want to opt one of them out while keeping
the rest.

Then rebuild, regenerate the docs, and commit both:

```bash
nix build
cd docs && bun run gen
```
