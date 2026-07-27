#!/usr/bin/env bun
/**
 * Converts `options.json` into the shape ndg expects.
 *
 * ndg (and nixos-render-docs, whose format it consumes) documents option
 * *declarations*: name, type, default, description, and the files an option is
 * declared in. It has no field for an option's evaluated value, and its
 * `declarations` normally point at the module that declared the option — for us
 * that would be a path inside nvf's store output, which is useless.
 *
 * So both the value and the provenance go into the description, which is the
 * only place ndg renders arbitrary content.
 *
 * `declarations` is deliberately left empty. ndg 2.9 assumes every declaration
 * is a path inside nixpkgs and unconditionally prefixes it with
 * `https://github.com/NixOS/nixpkgs/blob/<revision>/`, with no option to point
 * it elsewhere. Putting `conf/config/ui.nix` there yields a dead nixpkgs link,
 * and an absolute URL is mangled into `…/nixpkgs/blob/master/https://…`. A
 * markdown link in the description is the only way to link our own repository.
 *
 * Usage: bun scripts/render-ndg-options.ts <options.json> <out.json>
 */
import {readFileSync, writeFileSync} from 'node:fs';
import {renderValueBlock, toNixText, type OptValue} from './value';
import type {OptionEntry, OptionsFile} from './render-options';

const REPO_BLOB = 'https://github.com/ItzEmoji/nvim/blob/main';

/** A `literalExpression` node, the only default shape nixos-render-docs accepts. */
interface LiteralExpression {
  _type: 'literalExpression';
  text: string;
}

export interface NdgOption {
  declarations: string[];
  description: string;
  loc: string[];
  readOnly: boolean;
  type: string;
  default?: LiteralExpression;
}

export type NdgOptions = Record<string, NdgOption>;

const VALUE_HEADING = '**Value in this configuration:**';
const DEFINED_HEADING = '**Defined in:**';

/** Renders an option's default as the literal expression ndg wants. */
export function defaultFor(value: OptValue): LiteralExpression | undefined {
  if (value === null || value === undefined) return undefined;
  const text =
    typeof value === 'object' &&
    !Array.isArray(value) &&
    (value as {__type?: string}).__type === 'nixExpression'
      ? (value as {code: string}).code
      : toNixText(value);
  return {_type: 'literalExpression', text};
}

/**
 * Builds the description ndg renders: nvf's own prose, then the value this
 * configuration sets. The description is passed through unescaped — ndg parses
 * markdown, so the MDX escaping the Docusaurus renderer needs would show up
 * here as literal backslashes.
 */
export function describe(entry: OptionEntry): string {
  const parts: string[] = [];
  if (entry.description) parts.push(entry.description.trim());
  parts.push(VALUE_HEADING, renderValueBlock(entry.value));

  if (entry.sourceFiles.length > 0) {
    const links = entry.sourceFiles
      .map((file) => `[\`${file}\`](${REPO_BLOB}/${file})`)
      .join(', ');
    parts.push(`${DEFINED_HEADING} ${links}`);
  }

  return parts.join('\n\n');
}

export function toNdgOption(entry: OptionEntry): NdgOption {
  const option: NdgOption = {
    // Intentionally empty — see the note at the top of this file.
    declarations: [],
    description: describe(entry),
    loc: entry.name.split('.'),
    readOnly: false,
    type: entry.type ?? 'unspecified',
  };

  const fallback = defaultFor(entry.default);
  if (fallback) option.default = fallback;

  return option;
}

export function toNdgOptions(input: OptionsFile): NdgOptions {
  const out: NdgOptions = {};
  for (const entry of input.options) out[entry.name] = toNdgOption(entry);
  return out;
}

if (import.meta.main) {
  const [inputPath, outPath] = process.argv.slice(2);
  if (!inputPath || !outPath) {
    console.error(
      'usage: bun scripts/render-ndg-options.ts <options.json> <out.json>',
    );
    process.exit(1);
  }

  const input = JSON.parse(readFileSync(inputPath, 'utf8')) as OptionsFile;
  if (input.schemaVersion !== 1) {
    console.error(`unsupported schemaVersion ${input.schemaVersion}, expected 1`);
    process.exit(1);
  }

  const options = toNdgOptions(input);
  writeFileSync(outPath, `${JSON.stringify(options, null, 2)}\n`);
  console.log(`wrote ${Object.keys(options).length} options to ${outPath}`);
}
