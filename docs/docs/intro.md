---
sidebar_position: 1
slug: /
title: Introduction
---

# nvf Neovim Configuration

A declaratively managed Neovim configuration built with [nvf](https://github.com/notashelf/nvf)
and pure Nix. Plugins, language servers, formatters and keybindings are all resolved and
pinned by Nix, so the editor is identical on every machine.

## Try it without installing

```bash
nix run github:ItzEmoji/nvim --accept-flake-config
```

## What this site documents

The [Keybindings](/docs/reference/keybindings) page lists every bind set through
`vim.keymaps`, generated directly from a Nix evaluation of the config. Some plugins
register their own mappings through their own submodules instead, so the page is not a
full mirror of the editor's binds. It is committed to the repo, so it can also go stale —
CI fails the PR if it no longer matches what the config generates.

You will usually not need it. Press the leader key in the editor and which-key shows you
descriptions for every bind, including the ones this page cannot see, grouped as you
type. That popup is the complete reference; the page is a searchable offline copy of the
part of it that comes from `vim.keymaps`.

The guides cover how the flake is put together and how language support is wired up.
