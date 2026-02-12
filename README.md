[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![Build nvf (x86_64, aarch64)](https://github.com/ItzEmoji/nvim/actions/workflows/cache.yaml/badge.svg)](https://github.com/ItzEmoji/nvim/actions/workflows/cache.yaml)
# NVF-Neovim-Config
A declaratively managed Neovim configuration using pure Nix and NVF.

## 🚀 Features

The crown jewel of this setup is the **nvf** (Neovim Flake) modular architecture. Rather than manually managing Lua files and lazy-loading scripts, the entire editor stack is managed declaratively through Nix options.

Capabilities:

- **Declarative Plugins:** Plugins are fetched and hashed by Nix, ensuring your editor works exactly the same on every machine, every time.

- **Integrated LSP:** Language Servers, formatters, and linters are configured directly via Nix, removing the need for `Mason` or external package managers.

- **Reproducibility:** The entire configuration, including Neovim core version and plugin commits, is locked in `flake.lock`.

- **Multi-Arch Support:** Fully supported and tested on both **x86-64** and **aarch64**.

## ⚡ Quick Start
You can try out this configuration instantly without cloning the repo.

```bash
nix run github:ItzEmoji/nvim --accept-flake-config
