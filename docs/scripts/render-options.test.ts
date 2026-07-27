import {describe, expect, test} from 'bun:test';
import {
  slugForSource,
  titleForSource,
  groupBySource,
  renderOption,
  renderPage,
  type OptionEntry,
} from './render-options';

const noice: OptionEntry = {
  name: 'vim.ui.noice.enable',
  type: 'boolean',
  description: 'Whether to enable Noice.',
  default: 'false',
  value: true,
  sourceFiles: ['conf/config/ui.nix'],
};

describe('slugForSource', () => {
  test('flattens nested paths', () => {
    expect(slugForSource('conf/plugins/nvim-cmp.nix')).toBe('plugins-nvim-cmp');
  });

  test('handles top-level files', () => {
    expect(slugForSource('conf/clipboard.nix')).toBe('clipboard');
  });
});

describe('titleForSource', () => {
  test('uses the bare file name', () => {
    expect(titleForSource('conf/plugins/nvim-cmp.nix')).toBe('nvim-cmp');
    expect(titleForSource('conf/clipboard.nix')).toBe('clipboard');
  });
});

describe('groupBySource', () => {
  test('groups options under their source file', () => {
    const grouped = groupBySource([noice]);
    expect([...grouped.keys()]).toEqual(['conf/config/ui.nix']);
    expect(grouped.get('conf/config/ui.nix')).toHaveLength(1);
  });

  test('lists an option under every file that defines it', () => {
    const shared: OptionEntry = {
      ...noice,
      name: 'vim.keymaps',
      sourceFiles: ['conf/config/keybinds.nix', 'conf/clipboard.nix'],
    };
    const grouped = groupBySource([shared]);
    expect([...grouped.keys()].sort()).toEqual([
      'conf/clipboard.nix',
      'conf/config/keybinds.nix',
    ]);
  });
});

describe('renderOption', () => {
  test('includes the option name as a heading', () => {
    expect(renderOption(noice)).toContain('### `vim.ui.noice.enable`');
  });

  test('includes the value in a nix fence', () => {
    expect(renderOption(noice)).toContain('```nix\ntrue\n```');
  });

  test('includes a short type inline', () => {
    expect(renderOption(noice)).toContain('boolean');
  });

  test('escapes MDX-hostile characters in descriptions', () => {
    const tricky: OptionEntry = {...noice, description: 'Use {a} or <b>.'};
    expect(renderOption(tricky)).toContain('Use \\{a\\} or \\<b\\>.');
  });

  test('collapses a very long type behind a details element', () => {
    const long: OptionEntry = {...noice, type: 'one of ' + 'x'.repeat(300)};
    const out = renderOption(long);
    expect(out).toContain('<details');
    expect(out).toContain('Show full type');
  });

  test('omits the default line when there is no default', () => {
    const noDefault: OptionEntry = {...noice, default: null};
    expect(renderOption(noDefault)).not.toContain('Default');
  });

  test('renders a scalar default inline as code', () => {
    const boolDefault: OptionEntry = {...noice, default: false};
    expect(renderOption(boolDefault)).toContain(
      '<strong>Default:</strong> <code>false</code>',
    );
  });

  test('renders a structured (list) default as a fenced block', () => {
    const listDefault: OptionEntry = {...noice, default: ['a', 'b']};
    const out = renderOption(listDefault);
    expect(out).toContain('<strong>Default:</strong></span>');
    expect(out).toContain('```nix\n[\n  "a"\n  "b"\n]\n```');
  });

  test('renders a structured (attrset) default as a fenced block', () => {
    const attrsDefault: OptionEntry = {...noice, default: {mode: 'a'}};
    const out = renderOption(attrsDefault);
    expect(out).toContain('<strong>Default:</strong></span>');
    expect(out).toContain('```nix\n{\n  mode = "a";\n}\n```');
  });

  test('renders a nixExpression default as its raw code in a fenced block', () => {
    const exprDefault: OptionEntry = {
      ...noice,
      default: {__type: 'nixExpression', code: 'pkgs.lib.mkDefault true'},
    };
    const out = renderOption(exprDefault);
    expect(out).toContain('<strong>Default:</strong></span>');
    expect(out).toContain('```nix\npkgs.lib.mkDefault true\n```');
  });

  test('renders nothing for a null default', () => {
    const nullDefault: OptionEntry = {...noice, default: null};
    expect(renderOption(nullDefault)).not.toContain('Default');
  });

  test('links to the defining file on GitHub', () => {
    expect(renderOption(noice)).toContain(
      'https://github.com/ItzEmoji/nvim/blob/main/conf/config/ui.nix',
    );
  });
});

describe('renderPage', () => {
  test('emits front matter with a title and sidebar position', () => {
    const page = renderPage('conf/config/ui.nix', [noice], 3);
    expect(page.startsWith('---\n')).toBe(true);
    expect(page).toContain('title: ui');
    expect(page).toContain('sidebar_position: 3');
  });

  test('warns that the file is generated', () => {
    const page = renderPage('conf/config/ui.nix', [noice], 1);
    expect(page).toContain('generated');
  });

  test('sorts options by name', () => {
    const b: OptionEntry = {...noice, name: 'vim.b'};
    const a: OptionEntry = {...noice, name: 'vim.a'};
    const page = renderPage('conf/config/ui.nix', [b, a], 1);
    expect(page.indexOf('`vim.a`')).toBeLessThan(page.indexOf('`vim.b`'));
  });
});
