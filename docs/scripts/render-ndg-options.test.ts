import {describe as group, expect, test} from 'bun:test';
import {defaultFor, describe, toNdgOption, toNdgOptions} from './render-ndg-options';
import type {OptionEntry} from './render-options';

const noice: OptionEntry = {
  name: 'vim.ui.noice.enable',
  type: 'boolean',
  description: 'Whether to enable Noice.',
  default: false,
  value: true,
  sourceFiles: ['conf/config/ui.nix'],
};

group('defaultFor', () => {
  test('omits a missing default', () => {
    expect(defaultFor(null)).toBeUndefined();
  });

  test('wraps a scalar as a literalExpression', () => {
    expect(defaultFor(false)).toEqual({
      _type: 'literalExpression',
      text: 'false',
    });
  });

  test('uses a nixExpression default verbatim', () => {
    expect(defaultFor({__type: 'nixExpression', code: 'mkDefault 3'})).toEqual({
      _type: 'literalExpression',
      text: 'mkDefault 3',
    });
  });

  test('renders a structured default as Nix', () => {
    expect(defaultFor(['a', 'b'])).toEqual({
      _type: 'literalExpression',
      text: '[\n  "a"\n  "b"\n]',
    });
  });
});

group('describe', () => {
  test('keeps the upstream description', () => {
    expect(describe(noice)).toContain('Whether to enable Noice.');
  });

  test('appends the evaluated value as a fenced block', () => {
    expect(describe(noice)).toContain('**Value in this configuration:**');
    expect(describe(noice)).toContain('```nix\ntrue\n```');
  });

  test('does not MDX-escape, because ndg renders plain markdown', () => {
    const tricky: OptionEntry = {...noice, description: 'Takes {a} and <b>.'};
    expect(describe(tricky)).toContain('Takes {a} and <b>.');
    expect(describe(tricky)).not.toContain('\\{');
  });

  test('still emits a value block when there is no description', () => {
    const bare: OptionEntry = {...noice, description: null};
    expect(describe(bare).startsWith('**Value in this configuration:**')).toBe(true);
  });

  test('links the defining conf/ file at our own repository', () => {
    expect(describe(noice)).toContain(
      '**Defined in:** [`conf/config/ui.nix`](https://github.com/ItzEmoji/nvim/blob/main/conf/config/ui.nix)',
    );
  });

  test('links every file for an option defined in more than one', () => {
    const shared: OptionEntry = {
      ...noice,
      sourceFiles: ['conf/plugins/lualine.nix', 'conf/vim-options.nix'],
    };
    const out = describe(shared);
    expect(out).toContain('conf/plugins/lualine.nix)');
    expect(out).toContain('conf/vim-options.nix)');
  });

  test('omits the provenance line when there are no source files', () => {
    expect(describe({...noice, sourceFiles: []})).not.toContain('**Defined in:**');
  });

  test('renders a whole-value Lua node as Lua', () => {
    const lua: OptionEntry = {
      ...noice,
      value: {__type: 'lua', code: 'return 1'},
    };
    expect(describe(lua)).toContain('```lua\nreturn 1\n```');
  });
});

group('toNdgOption', () => {
  test('leaves declarations empty, because ndg forces a nixpkgs URL onto them', () => {
    expect(toNdgOption(noice).declarations).toEqual([]);
  });

  test('splits the option path into loc', () => {
    expect(toNdgOption(noice).loc).toEqual(['vim', 'ui', 'noice', 'enable']);
  });

  test('carries the type through', () => {
    expect(toNdgOption(noice).type).toBe('boolean');
  });

  test('falls back when the type is unknown', () => {
    expect(toNdgOption({...noice, type: null}).type).toBe('unspecified');
  });

  test('omits the default key entirely when there is none', () => {
    expect(toNdgOption({...noice, default: null})).not.toHaveProperty('default');
  });
});

group('toNdgOptions', () => {
  test('keys the map by option name', () => {
    expect(Object.keys(toNdgOptions({schemaVersion: 1, options: [noice]}))).toEqual([
      'vim.ui.noice.enable',
    ]);
  });
});
