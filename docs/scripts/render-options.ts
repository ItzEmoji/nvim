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
import {escapeMdx, renderValueBlock, type OptValue} from './value';

export interface OptionEntry {
  name: string;
  type: string | null;
  description: string | null;
  default: string | null;
  value: OptValue;
  sourceFiles: string[];
}

export interface OptionsFile {
  schemaVersion: number;
  options: OptionEntry[];
}

const REPO_BLOB = 'https://github.com/ItzEmoji/nvim/blob/main';
const TYPE_COLLAPSE_THRESHOLD = 200;
const OUT_DIR = 'docs/reference/options';

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
 * Renders the "Default:" metadata item. Most defaults are short scalars that fit
 * inline as `<code>...</code>`. Some nvf options (e.g. Lua loader snippets) carry a
 * `defaultText` that is itself a fenced markdown code block; splicing that verbatim
 * into an inline `<code>` span breaks MDX, because the embedded ``` fence terminates
 * the surrounding paragraph before the closing `</code>` is reached. Detect that case
 * and render the fenced block on its own line instead, matching the pattern already
 * used for oversized types.
 */
function renderDefault(defaultText: string): string {
  const trimmed = defaultText.trim();
  const fenceMatch = trimmed.match(/^```(\S*)\n([\s\S]*?)\n```$/);
  if (fenceMatch) {
    const lang = fenceMatch[1] || 'text';
    const code = fenceMatch[2];
    return [
      '<span class="option-meta__item"><strong>Default:</strong></span>',
      '',
      `\`\`\`${lang}`,
      code,
      '```',
    ].join('\n');
  }
  if (trimmed.includes('\n')) {
    return [
      '<span class="option-meta__item"><strong>Default:</strong></span>',
      '',
      '```',
      trimmed,
      '```',
    ].join('\n');
  }
  return `<span class="option-meta__item"><strong>Default:</strong> <code>${escapeMdx(defaultText)}</code></span>`;
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
    parts.push(escapeMdx(entry.description), '');
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
  const sorted = [...entries].sort((a, b) => a.name.localeCompare(b.name));
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

  writeFileSync(
    join(outDir, '_category_.json'),
    `${JSON.stringify({label: 'By source file', position: 2}, null, 2)}\n`,
  );
  written.push(join(outDir, '_category_.json'));

  sourceFiles.forEach((sourceFile, index) => {
    const path = join(outDir, `${slugForSource(sourceFile)}.mdx`);
    writeFileSync(path, renderPage(sourceFile, grouped.get(sourceFile)!, index + 1));
    written.push(path);
  });

  return written;
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
}
