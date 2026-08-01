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

The [Keybindings](/docs/reference/keybindings) page lists every bind this configuration
sets, generated directly from a Nix evaluation of it. It cannot drift from the source,
because it is produced from the source.

You will usually not need it. Press `<Space>` in the editor and which-key shows you the
same descriptions, grouped the same way, as you type. The page is the searchable offline
copy.

The guides cover how the flake is put together and how language support is wired up.
