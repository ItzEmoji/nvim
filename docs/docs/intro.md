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

The [Option Reference](/docs/category/option-reference) is generated directly from a Nix
evaluation of this configuration. Every page lists the options one `conf/` file sets, their
evaluated values, and their types as nvf declares them. It cannot drift from the source,
because it is produced from the source.
