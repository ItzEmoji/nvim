---
sidebar_position: 3
title: How This Config Is Built
---

# How This Config Is Built

The flake uses [flake-parts](https://flake.parts) with
[import-tree](https://github.com/vic/import-tree), so directories are wired up by
convention rather than by an explicit import list. `flake.nix` imports the whole
`modules/` tree with a single `inputs.import-tree ./modules` call.

| Directory | Role |
| --- | --- |
| `conf/` | The Neovim configuration itself. Every file is an nvf module. |
| `modules/` | flake-parts modules — packages, formatting, devShell, docs. |
| `nix/` | Plain Nix helpers used by those modules, not flake-parts modules themselves. |
| `docs/` | This site. |

`conf/` is wired into the flake by the files under `modules/` that build the editor —
`modules/packages.nix` and `modules/docs.nix` each pass
`inputs.import-tree ../conf` as an nvf module list, so every file in `conf/` is
picked up automatically. Adding a file to `conf/` is enough to activate it; there is
no separate registration step. `nix/` is different: it holds plain Nix expressions,
such as `nix/extract-options.nix`, that `modules/docs.nix` calls into directly — they
are not themselves flake-parts modules and are not touched by `import-tree`.

## Where this site comes from

`nix build .#options-json` evaluates the configuration and walks the resulting option
tree, keeping every option that a file under `conf/` defines. A renderer turns that
JSON into the pages under Option Reference. Because the data comes from the same
evaluation that builds the editor, the reference cannot describe options the editor
does not actually have.
