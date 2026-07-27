import {describe, expect, test} from 'bun:test';
import {toNixText, renderValueBlock, escapeMdx} from './value';

describe('toNixText', () => {
  test('renders booleans', () => {
    expect(toNixText(true)).toBe('true');
    expect(toNixText(false)).toBe('false');
  });

  test('renders null', () => {
    expect(toNixText(null)).toBe('null');
  });

  test('renders numbers', () => {
    expect(toNixText(42)).toBe('42');
  });

  test('quotes strings', () => {
    expect(toNixText('<leader>j')).toBe('"<leader>j"');
  });

  test('escapes quotes and backslashes in strings', () => {
    expect(toNixText('say "hi"')).toBe('"say \\"hi\\""');
    expect(toNixText('a\\b')).toBe('"a\\\\b"');
  });

  test('renders an empty list', () => {
    expect(toNixText([])).toBe('[ ]');
  });

  test('renders a list one item per line', () => {
    expect(toNixText(['a', 'b'])).toBe('[\n  "a"\n  "b"\n]');
  });

  test('renders an empty attrset', () => {
    expect(toNixText({})).toBe('{ }');
  });

  test('renders an attrset with sorted keys', () => {
    expect(toNixText({b: 1, a: 2})).toBe('{\n  a = 2;\n  b = 1;\n}');
  });

  test('leaves hyphenated names unquoted — they are valid Nix identifiers', () => {
    expect(toNixText({'nvim-cmp': true})).toBe('{\n  nvim-cmp = true;\n}');
  });

  test('quotes attribute names that are not valid identifiers', () => {
    expect(toNixText({'foo.bar': true})).toBe('{\n  "foo.bar" = true;\n}');
    expect(toNixText({'with space': true})).toBe('{\n  "with space" = true;\n}');
  });

  test('nests structures with increasing indent', () => {
    expect(toNixText({outer: {inner: true}})).toBe(
      '{\n  outer = {\n    inner = true;\n  };\n}',
    );
  });

  test('renders a derivation as a readable marker', () => {
    expect(
      toNixText({__type: 'derivation', name: 'vimplugin-cmp-buffer', path: '/nix/store/x'}),
    ).toBe('<derivation vimplugin-cmp-buffer>');
  });

  test('renders a function marker', () => {
    expect(toNixText({__type: 'function'})).toBe('<function>');
  });

  test('renders an error marker', () => {
    expect(toNixText({__type: 'error'})).toBe('<value could not be evaluated>');
  });

  test('renders an elided marker', () => {
    expect(toNixText({__type: 'elided'})).toBe('<elided: too deeply nested>');
  });

  test('renders a nested lua node using the mkLuaInline idiom', () => {
    // Built line by line because the expected text contains Nix's '' delimiters.
    const expected = [
      '{',
      "  sel = mkLuaInline ''",
      '    return 1',
      "  '';",
      '}',
    ].join('\n');
    expect(toNixText({sel: {__type: 'lua', code: 'return 1'}})).toBe(expected);
  });
});

describe('renderValueBlock', () => {
  test('a whole-value lua node becomes a lua fence', () => {
    expect(renderValueBlock({__type: 'lua', code: 'return 1'})).toBe(
      '```lua\nreturn 1\n```',
    );
  });

  test('anything else becomes a nix fence', () => {
    expect(renderValueBlock(true)).toBe('```nix\ntrue\n```');
  });
});

describe('escapeMdx', () => {
  test('escapes braces and angle brackets', () => {
    expect(escapeMdx('a {b} <c>')).toBe('a \\{b\\} \\<c\\>');
  });

  test('leaves ordinary prose untouched', () => {
    expect(escapeMdx('Whether to enable Noice.')).toBe('Whether to enable Noice.');
  });
});
