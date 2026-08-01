# Documentation site

A Docusaurus site documenting this Neovim configuration. The keybindings page at
`docs/reference/keybindings.mdx` is **generated** — never edit it by hand.

## Development

All commands need `bun`, provided by the flake devShell:

```bash
nix develop -c bash
cd docs
bun install
bun start
```

## Regenerating the keybindings page

After changing any keybinding or which-key group under `conf/`, regenerate and commit
the page:

```bash
bun run gen
```

This runs `nix build '..#keymaps-json'` and then the renderer. CI fails if the
committed output is stale.

## Deployment

Deployed by Cloudflare's git integration on push to `main`. Dashboard settings:

| Setting | Value |
| --- | --- |
| Root directory | `docs` |
| Build command | `bun run build` |
| Output directory | `build` |

`bun run build` needs no Nix, because the generated MDX is committed.

To serve the site from a subpath later (a combined `docs.itzemoji.com` repo), set the
`DOCS_BASE_URL` and `DOCS_URL` environment variables in the Cloudflare build settings.
