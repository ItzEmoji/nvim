# Documentation site

A Docusaurus site documenting this Neovim configuration. The option reference under
`docs/reference/options/` is **generated** — never edit those files by hand.

## Development

All commands need `bun`, provided by the flake devShell:

```bash
nix develop -c bash
cd docs
bun install
bun start
```

## Regenerating the option reference

After changing anything under `conf/`, regenerate and commit the reference:

```bash
bun run gen
```

This runs `nix build '..#options-json'` and then the renderer. CI fails if the
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
