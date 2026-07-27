/**
 * Renders the structured option values emitted by `nix/extract-options.nix` into
 * markdown. The extractor deliberately hands over data rather than text, so every
 * formatting decision lives here.
 */

type Tagged =
  | {__type: 'lua'; code: string}
  | {__type: 'derivation'; name: string; path: string}
  | {__type: 'function'}
  | {__type: 'error'}
  | {__type: 'elided'}
  | {__type: 'unknown'}
  | {__type: 'nixExpression'; code: string};

export type OptValue =
  | null
  | boolean
  | number
  | string
  | OptValue[]
  | Tagged
  | {[key: string]: OptValue};

const IDENTIFIER = /^[A-Za-z_][A-Za-z0-9_'-]*$/;

function isTagged(v: OptValue): v is Tagged {
  return typeof v === 'object' && v !== null && !Array.isArray(v) && '__type' in v;
}

function quoteString(s: string): string {
  const escaped = s.replace(/\\|"|\$\{/g, (m) => (m === '${' ? '\\${' : `\\${m}`));
  return `"${escaped}"`;
}

function quoteAttrName(name: string): string {
  return IDENTIFIER.test(name) ? name : quoteString(name);
}

function indentLines(text: string, pad: string): string {
  return text
    .split('\n')
    .map((line) => (line.length > 0 ? pad + line : line))
    .join('\n');
}

/** Escapes the two metacharacters Nix's `''`-indented strings are sensitive to. */
function escapeNixIndentedString(s: string): string {
  return s.replace(/''|\$\{/g, (m) => (m === "''" ? "'''" : "''${"));
}

/** Renders a nested Lua snippet the way it appears in the Nix source. */
function luaInline(code: string, indent: number): string {
  const pad = '  '.repeat(indent + 1);
  const escaped = escapeNixIndentedString(code.trimEnd());
  return `mkLuaInline ''\n${indentLines(escaped, pad)}\n${'  '.repeat(indent)}''`;
}

export function toNixText(v: OptValue, indent = 0): string {
  const pad = '  '.repeat(indent);
  const innerPad = '  '.repeat(indent + 1);

  if (v === null) return 'null';
  if (typeof v === 'boolean') return v ? 'true' : 'false';
  if (typeof v === 'number') return String(v);
  if (typeof v === 'string') return quoteString(v);

  if (Array.isArray(v)) {
    if (v.length === 0) return '[ ]';
    const items = v.map((item) => `${innerPad}${toNixText(item, indent + 1)}`);
    return `[\n${items.join('\n')}\n${pad}]`;
  }

  if (isTagged(v)) {
    switch (v.__type) {
      case 'lua':
        return luaInline(v.code, indent);
      case 'derivation':
        return `<derivation ${v.name}>`;
      case 'function':
        return '<function>';
      case 'error':
        return '<value could not be evaluated>';
      case 'elided':
        return '<elided: too deeply nested>';
      case 'nixExpression':
        return v.code;
      default:
        return '<unrepresentable>';
    }
  }

  const keys = Object.keys(v).sort();
  if (keys.length === 0) return '{ }';
  const entries = keys.map(
    (key) => `${innerPad}${quoteAttrName(key)} = ${toNixText(v[key], indent + 1)};`,
  );
  return `{\n${entries.join('\n')}\n${pad}}`;
}

/**
 * Picks a backtick fence long enough that it cannot be closed early by a run of
 * backticks already present in the content (e.g. a `defaultText` that is itself
 * markdown containing a ```-fenced snippet).
 */
function fenceFor(content: string): string {
  const runs: string[] = content.match(/`+/g) ?? [];
  const longestRun = runs.reduce((max, run) => Math.max(max, run.length), 0);
  return '`'.repeat(Math.max(3, longestRun + 1));
}

/** Wraps a value in the appropriate fenced code block. */
export function renderValueBlock(v: OptValue): string {
  if (isTagged(v) && v.__type === 'lua') {
    const code = v.code.trimEnd();
    const fence = fenceFor(code);
    return [`${fence}lua`, code, fence].join('\n');
  }
  if (isTagged(v) && v.__type === 'nixExpression') {
    const code = v.code.trimEnd();
    const fence = fenceFor(code);
    return [`${fence}nix`, code, fence].join('\n');
  }
  const text = toNixText(v);
  const fence = fenceFor(text);
  return [`${fence}nix`, text, fence].join('\n');
}

/** Escapes characters MDX would otherwise interpret as JSX. */
export function escapeMdx(s: string): string {
  return s.replace(/[{}<>]/g, (c) => `\\${c}`);
}
