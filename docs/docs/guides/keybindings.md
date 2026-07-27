---
sidebar_position: 1
title: Keybindings
---

# Keybindings

The leader key is `<Space>`. Bindings are declared in `conf/config/keybinds.nix` and
`conf/clipboard.nix`; the generated
[option reference](/docs/category/option-reference) lists their exact values.

## Motion

`flash.nvim` provides jump motions. Its defaults (`s` / `S`) collide with `mini.surround`,
which owns `s` as a normal-mode prefix, so the jump bindings are remapped:

| Binding | Action |
| --- | --- |
| `<leader>j` | Flash jump |
| `<leader>J` | Flash treesitter jump |
