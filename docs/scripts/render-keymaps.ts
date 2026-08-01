#!/usr/bin/env bun
/**
 * Turns `keymaps.json` — produced by `nix build .#keymaps-json` — into the one
 * generated page this site has: `docs/reference/keybindings.mdx`.
 *
 * Usage: bun scripts/render-keymaps.ts <path-to-keymaps.json>
 */
import {readFileSync, writeFileSync} from 'node:fs';
import {join} from 'node:path';
import {
  renderKeybindingsPage,
  type Keymap,
  type WhichKeyRegister,
} from './keymaps';

export interface KeymapsFile {
  schemaVersion: number;
  leader: string;
  groups: WhichKeyRegister;
  keymaps: Keymap[];
}

// Resolved relative to this file's own location, not the process cwd, so the
// output lands in the same place regardless of where the renderer is invoked from.
const OUT_PATH = join(
  import.meta.dir,
  '..',
  'docs',
  'reference',
  'keybindings.mdx',
);

/**
 * Writes the keybindings page. Returns false when the config sets no keymaps, so
 * the caller can skip the page rather than emit an empty one.
 */
const SUPPORTED_SCHEMA_VERSION = 1;

export function writeKeybindings(input: KeymapsFile, outPath: string): boolean {
  if (input.schemaVersion !== SUPPORTED_SCHEMA_VERSION) {
    throw new Error(
      `unsupported schemaVersion ${input.schemaVersion}, expected ${SUPPORTED_SCHEMA_VERSION}`,
    );
  }

  if (!Array.isArray(input.keymaps) || input.keymaps.length === 0) return false;

  if (typeof input.leader !== 'string') {
    throw new Error(
      'keymaps.json has no leader; refusing to guess one, because the wrong ' +
        'leader documents binds nobody can press',
    );
  }

  writeFileSync(
    outPath,
    renderKeybindingsPage(input.keymaps, input.groups ?? {}, input.leader),
  );
  return true;
}

if (import.meta.main) {
  const inputPath = process.argv[2];
  if (!inputPath) {
    console.error('usage: bun scripts/render-keymaps.ts <path-to-keymaps.json>');
    process.exit(1);
  }

  const input = JSON.parse(readFileSync(inputPath, 'utf8')) as KeymapsFile;

  try {
    if (writeKeybindings(input, OUT_PATH)) {
      console.log(`wrote ${OUT_PATH}`);
    } else {
      console.log('no keymaps set; skipped the keybindings page');
    }
  } catch (err) {
    console.error(err instanceof Error ? err.message : String(err));
    process.exit(1);
  }
}
