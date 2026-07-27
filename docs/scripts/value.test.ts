import {describe, expect, test} from 'bun:test';
import {toNixText, renderValueBlock, escapeMdx, escapeMdxDescription} from './value';

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

  test('escapes interpolation syntax in strings', () => {
    expect(toNixText('${foo}')).toBe('"\\${foo}"');
  });

  test('escapes a backslash immediately before interpolation without double-escaping', () => {
    expect(toNixText('a\\${foo}')).toBe('"a\\\\\\${foo}"');
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

  test('escapes a literal \'\' inside lua code embedded in the nix string', () => {
    const expected = [
      '{',
      "  sel = mkLuaInline ''",
      "    local s = '''",
      "  '';",
      '}',
    ].join('\n');
    expect(toNixText({sel: {__type: 'lua', code: "local s = ''"}})).toBe(expected);
  });

  test('escapes a literal ${ inside lua code embedded in the nix string', () => {
    const expected = [
      '{',
      "  sel = mkLuaInline ''",
      "    local x = \"''${foo}\"",
      "  '';",
      '}',
    ].join('\n');
    expect(toNixText({sel: {__type: 'lua', code: 'local x = "${foo}"'}})).toBe(expected);
  });

  test('escapes both \'\' and ${ in the same lua snippet without corrupting either', () => {
    const expected = [
      '{',
      "  sel = mkLuaInline ''",
      "    local s = '''; local x = \"''${foo}\"",
      "  '';",
      '}',
    ].join('\n');
    expect(
      toNixText({sel: {__type: 'lua', code: "local s = ''; local x = \"${foo}\""}}),
    ).toBe(expected);
  });

  test('renders the unknown tag as unrepresentable', () => {
    expect(toNixText({__type: 'unknown'})).toBe('<unrepresentable>');
  });

  test('renders an attrset with an unrecognized __type as an ordinary attrset', () => {
    // A real nvf `setupOpts` attrset could legitimately carry a literal `__type` key.
    // Only the extractor's own known tags should be treated as tagged forms —
    // anything else must render its data, not `<unrepresentable>`.
    expect(toNixText({__type: 'setupOpts', foo: true})).toBe(
      '{\n  __type = "setupOpts";\n  foo = true;\n}',
    );
  });

  test('escapes a literal \'\'\' (three quotes) inside lua code without corrupting it', () => {
    const expected = [
      '{',
      "  sel = mkLuaInline ''",
      "    abc''''def",
      "  '';",
      '}',
    ].join('\n');
    expect(toNixText({sel: {__type: 'lua', code: "abc'''def"}})).toBe(expected);
  });

  test("escapes a literal ''\${ inside lua code without corrupting it", () => {
    const expected = [
      '{',
      "  sel = mkLuaInline ''",
      "    abc'''''\${def",
      "  '';",
      '}',
    ].join('\n');
    expect(toNixText({sel: {__type: 'lua', code: "abc''${def"}})).toBe(expected);
  });

  test('escapes a literal $${ inside lua code without corrupting it', () => {
    const expected = [
      '{',
      "  sel = mkLuaInline ''",
      "    abc$''\${def",
      "  '';",
      '}',
    ].join('\n');
    expect(toNixText({sel: {__type: 'lua', code: 'abc$${def'}})).toBe(expected);
  });

  test('renders a nixExpression tag as its raw code, unquoted and unescaped', () => {
    expect(toNixText({__type: 'nixExpression', code: 'pkgs.lib.mkDefault true'})).toBe(
      'pkgs.lib.mkDefault true',
    );
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

describe('escapeMdxDescription', () => {
  test('leaves braces inside a backtick span untouched', () => {
    expect(escapeMdxDescription('Set via `{ foo = "bar"; }`.')).toBe(
      'Set via `{ foo = "bar"; }`.',
    );
  });

  test('escapes braces outside any backtick span', () => {
    expect(escapeMdxDescription('Use {a} or <b>.')).toBe('Use \\{a\\} or \\<b\\>.');
  });

  test('escapes prose braces but leaves an adjacent code span untouched', () => {
    expect(escapeMdxDescription('Wrap {value} in `{foo = "bar";}` for Lua.')).toBe(
      'Wrap \\{value\\} in `{foo = "bar";}` for Lua.',
    );
  });
});
