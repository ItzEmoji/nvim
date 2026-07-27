#!/usr/bin/env bun
/**
 * Turns `options.json` — produced by `nix build .#options-json` — into the MDX pages
 * under `docs/reference/options/`. One page per `conf/` source file, because that is
 * how the configuration is organized.
 *
 * Usage: bun scripts/render-options.ts <path-to-options.json>
 */
import {mkdirSync, readFileSync, rmSync, writeFileSync} from 'node:fs';
import {basename, join} from 'node:path';
import {escapeMdx, escapeMdxDescription, renderValueBlock, toNixText, type OptValue} from './value';
import {
  renderKeybindingsPage,
  type Keymap,
  type WhichKeyRegister,
} from './keymaps';

const DEFAULT_INLINE_THRESHOLD = 80;

export interface OptionEntry {
  name: string;
  type: string | null;
  description: string | null;
  default: OptValue;
  value: OptValue;
  sourceFiles: string[];
}

export interface OptionsFile {
  schemaVersion: number;
  options: OptionEntry[];
}

const REPO_BLOB = 'https://github.com/ItzEmoji/nvim/blob/main';
const TYPE_COLLAPSE_THRESHOLD = 200;
// Resolved relative to this file's own location, not the process cwd, so the
// output lands in the same place regardless of where the renderer is invoked from.
const OUT_DIR = join(import.meta.dir, '..', 'docs', 'reference', 'options');
const KEYBINDINGS_PAGE = join(
  import.meta.dir,
  '..',
  'docs',
  'reference',
  'keybindings.mdx',
);

/** `conf/plugins/nvim-cmp.nix` -> `plugins-nvim-cmp` */
export function slugForSource(sourceFile: string): string {
  return sourceFile
    .replace(/^conf\//, '')
    .replace(/\.nix$/, '')
    .replace(/\//g, '-');
}

/** `conf/plugins/nvim-cmp.nix` -> `nvim-cmp` */
export function titleForSource(sourceFile: string): string {
  return basename(sourceFile, '.nix');
}

export function groupBySource(options: OptionEntry[]): Map<string, OptionEntry[]> {
  const grouped = new Map<string, OptionEntry[]>();
  for (const option of options) {
    for (const file of option.sourceFiles) {
      const bucket = grouped.get(file);
      if (bucket) bucket.push(option);
      else grouped.set(file, [option]);
    }
  }
  return grouped;
}

// MDX v3 does not run markdown syntax (like `**bold**`) inside raw HTML blocks, and it
// requires a blank line between raw HTML and any markdown/text content around it. So the
// metadata items below use literal `<strong>` tags instead of `**...**`, and every HTML
// block is separated from its neighbours by a blank line.

/**
 * Renders the "Default:" metadata item. A simple scalar default (boolean, number, or
 * a short single-line string) fits inline as `<code>...</code>`. Anything else —
 * lists, attrsets, Lua snippets, Nix expressions carried over from `defaultText`,
 * derivations, and so on — renders as its own fenced block below the label, via the
 * same structured renderer used for `Value:`, matching the pattern already used for
 * oversized types.
 */
function renderDefault(value: OptValue): string {
  const isSimpleScalar =
    typeof value === 'boolean' ||
    typeof value === 'number' ||
    (typeof value === 'string' && !value.includes('\n') && value.length <= DEFAULT_INLINE_THRESHOLD);

  if (isSimpleScalar) {
    // Route scalars through the same Nix-quoting `toNixText` uses for `Value:`, so a
    // string default like `"<leader>j"` is quoted (matching Value), an empty string
    // is visible as `""` rather than an invisible empty `<code>`, and the string
    // `"false"` stays distinguishable from the boolean `false`.
    const text = escapeMdx(toNixText(value));
    return `<span class="option-meta__item"><strong>Default:</strong> <code>${text}</code></span>`;
  }

  return [
    '<span class="option-meta__item"><strong>Default:</strong></span>',
    '',
    renderValueBlock(value),
  ].join('\n');
}

function renderType(type: string | null): string {
  if (!type) return '';
  if (type.length <= TYPE_COLLAPSE_THRESHOLD) {
    return `<span class="option-meta__item"><strong>Type:</strong> <code>${escapeMdx(type)}</code></span>`;
  }
  // Enormous enum types (nvf's plugin lists run to hundreds of entries) would swamp
  // the page, so show a truncated form and hide the rest.
  const preview = `${type.slice(0, 80)}…`;
  return [
    `<span class="option-meta__item"><strong>Type:</strong> <code>${escapeMdx(preview)}</code></span>`,
    '',
    '<details class="option-type-details">',
    '<summary>Show full type</summary>',
    '',
    '```',
    type,
    '```',
    '',
    '</details>',
  ].join('\n');
}

export function renderOption(entry: OptionEntry): string {
  const parts: string[] = [`### \`${entry.name}\``, ''];

  if (entry.description) {
    parts.push(escapeMdxDescription(entry.description), '');
  }

  const meta: string[] = ['<div class="option-meta">', ''];
  const typeText = renderType(entry.type);
  if (typeText) meta.push(typeText, '');
  if (entry.default !== null) {
    meta.push(renderDefault(entry.default), '');
  }
  const links = entry.sourceFiles
    .map((file) => `[\`${file}\`](${REPO_BLOB}/${file})`)
    .join(', ');
  meta.push(
    `<span class="option-meta__item"><strong>Defined in:</strong> ${links}</span>`,
    '',
  );
  meta.push('</div>', '');
  parts.push(...meta);

  parts.push('**Value:**', '', renderValueBlock(entry.value), '');
  return parts.join('\n');
}

export function renderPage(
  sourceFile: string,
  entries: OptionEntry[],
  position: number,
): string {
  const title = titleForSource(sourceFile);
  // Bytewise, not locale-aware: this must agree with the extractor's own bytewise
  // `<` ordering (nix/extract-options.nix), since reproducible output is what the
  // CI drift check depends on, and `localeCompare` is locale- and ICU-dependent.
  const sorted = [...entries].sort((a, b) => (a.name < b.name ? -1 : a.name > b.name ? 1 : 0));
  const count = sorted.length;
  const noun = count === 1 ? 'option' : 'options';

  const header = [
    '---',
    `title: ${title}`,
    `sidebar_label: ${title}`,
    `sidebar_position: ${position}`,
    `description: Options set by ${sourceFile}`,
    '---',
    '',
    `# \`${sourceFile}\``,
    '',
    '{/* This page is generated by docs/scripts/render-options.ts. Do not edit it by hand. */}',
    '',
    `This page is generated from a Nix evaluation of the configuration. It lists the ` +
      `${count} ${noun} that [\`${sourceFile}\`](${REPO_BLOB}/${sourceFile}) sets.`,
    '',
    '',
  ].join('\n');

  return header + sorted.map(renderOption).join('\n');
}

export function writeSite(input: OptionsFile, outDir: string): string[] {
  const grouped = groupBySource(input.options);
  const sourceFiles = [...grouped.keys()].sort();

  // Wipe the directory so options removed from `conf/` do not leave stale pages behind.
  rmSync(outDir, {recursive: true, force: true});
  mkdirSync(outDir, {recursive: true});

  const written: string[] = [];

  sourceFiles.forEach((sourceFile, index) => {
    const path = join(outDir, `${slugForSource(sourceFile)}.mdx`);
    writeFileSync(path, renderPage(sourceFile, grouped.get(sourceFile)!, index + 1));
    written.push(path);
  });

  return written;
}

/** Looks up one option's evaluated value by name. */
function valueOf(input: OptionsFile, name: string): OptValue | undefined {
  return input.options.find((option) => option.name === name)?.value;
}

/**
 * Writes the single keybindings page from `vim.keymaps`, labelled with the
 * which-key group names. Returns false when the config sets no keymaps, so the
 * caller can skip the page rather than emit an empty one.
 */
export function writeKeybindings(input: OptionsFile, outPath: string): boolean {
  const keymaps = valueOf(input, 'vim.keymaps');
  if (!Array.isArray(keymaps) || keymaps.length === 0) return false;

  const raw = valueOf(input, 'vim.binds.whichKey.register');
  const register: WhichKeyRegister = {};
  if (raw && typeof raw === 'object' && !Array.isArray(raw)) {
    for (const [prefix, label] of Object.entries(raw)) {
      if (typeof label === 'string') register[prefix] = label;
    }
  }

  writeFileSync(
    outPath,
    renderKeybindingsPage(keymaps as unknown as Keymap[], register),
  );
  return true;
}

if (import.meta.main) {
  const inputPath = process.argv[2];
  if (!inputPath) {
    console.error('usage: bun scripts/render-options.ts <path-to-options.json>');
    process.exit(1);
  }

  const input = JSON.parse(readFileSync(inputPath, 'utf8')) as OptionsFile;
  if (input.schemaVersion !== 1) {
    console.error(`unsupported schemaVersion ${input.schemaVersion}, expected 1`);
    process.exit(1);
  }

  const written = writeSite(input, OUT_DIR);
  console.log(`wrote ${written.length} files to ${OUT_DIR}`);

  if (writeKeybindings(input, KEYBINDINGS_PAGE)) {
    console.log(`wrote ${KEYBINDINGS_PAGE}`);
  } else {
    console.log('no keymaps set; skipped the keybindings page');
  }
}
