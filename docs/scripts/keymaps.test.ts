import {describe, expect, test} from 'bun:test';
import {
  escapeMdx,
  escapeMdxDescription,
  formatLeader,
  formatModes,
  groupKeymaps,
  groupLabelFor,
  normalizeModes,
  renderKeybindingsPage,
  type Keymap,
  type WhichKeyRegister,
} from './keymaps';

const register: WhichKeyRegister = {
  '<leader>f': 'Find',
  '<leader>g': 'Git',
  '<leader>b': 'Buffer',
  '<leader>bs': 'BufferLineSort',
  '<leader>h': '+Gitsigns',
};

const findFile: Keymap = {
  key: '<leader>ff',
  mode: 'n',
  desc: 'Find File',
};

// Keeps the existing page tests readable now that the leader is a parameter:
// almost every case cares about the bindings, not the leader.
function render(
  keymaps: Keymap[],
  reg: WhichKeyRegister = register,
  leader = ' ',
): string {
  return renderKeybindingsPage(keymaps, reg, leader);
}

describe('normalizeModes', () => {
  test('wraps a bare mode', () => {
    expect(normalizeModes('n')).toEqual(['n']);
  });

  test('passes a list through', () => {
    expect(normalizeModes(['n', 'x'])).toEqual(['n', 'x']);
  });
});

describe('formatModes', () => {
  test('hides plain normal mode, which is the overwhelming default', () => {
    expect(formatModes('n')).toBe('');
    expect(formatModes(['n'])).toBe('');
  });

  test('shows anything else', () => {
    expect(formatModes(['n', 'x'])).toBe('n, x');
    expect(formatModes(['v'])).toBe('v');
  });
});

describe('groupLabelFor', () => {
  test('uses the registered which-key label', () => {
    expect(groupLabelFor('<leader>ff', register)).toBe('Find');
  });

  test('prefers the longest matching prefix', () => {
    expect(groupLabelFor('<leader>bsi', register)).toBe('BufferLineSort');
  });

  test('does not put a prefix key inside its own group', () => {
    expect(groupLabelFor('<leader>f', register)).toBe('Other leader keys');
  });

  test('buckets unregistered leader keys together', () => {
    expect(groupLabelFor('<leader>n', register)).toBe('Other leader keys');
  });

  test("strips which-key's `+` prefix from the label", () => {
    expect(groupLabelFor('<leader>hs', register)).toBe('Gitsigns');
  });

  test('buckets non-leader keys separately', () => {
    expect(groupLabelFor('gd', register)).toBe('Without leader');
    expect(groupLabelFor('<c-n>', register)).toBe('Without leader');
  });
});

describe('groupKeymaps', () => {
  test('sorts named groups alphabetically and puts catch-alls last', () => {
    const groups = groupKeymaps(
      [
        {key: 'gd', mode: 'n', desc: 'Definition'},
        {key: '<leader>n', mode: 'n', desc: 'Notifications'},
        findFile,
        {key: '<leader>gg', mode: 'n', desc: 'Lazygit'},
      ],
      register,
    );
    expect(groups.map((g) => g.label)).toEqual([
      'Find',
      'Git',
      'Other leader keys',
      'Without leader',
    ]);
  });

  test('sorts binds within a group by key', () => {
    const groups = groupKeymaps(
      [
        {key: '<leader>fr', mode: 'n', desc: 'Recent'},
        findFile,
        {key: '<leader>fb', mode: 'n', desc: 'Buffer'},
      ],
      register,
    );
    expect(groups[0].entries.map((e) => e.key)).toEqual([
      '<leader>fb',
      '<leader>ff',
      '<leader>fr',
    ]);
  });

  test('omits groups that have no binds', () => {
    const groups = groupKeymaps([findFile], register);
    expect(groups.map((g) => g.label)).toEqual(['Find']);
  });
});

describe('renderKeybindingsPage', () => {
  test('emits front matter and a heading', () => {
    const page = render([findFile]);
    expect(page.startsWith('---\n')).toBe(true);
    expect(page).toContain('title: Keybindings');
    expect(page).toContain('# Keybindings');
  });

  test('states how many binds there are', () => {
    const page = render([findFile]);
    expect(page).toContain('lists the 1 binds');
  });

  test('warns that the page is generated', () => {
    expect(render([findFile])).toContain('generated');
  });

  test('renders a group heading and the bind', () => {
    const page = render([findFile]);
    expect(page).toContain('## Find');
    expect(page).toContain('| `<leader>ff` | Find File |');
  });

  test('omits the mode column when every bind is normal-mode-only', () => {
    const page = render([findFile]);
    expect(page).toContain('| Key | Action |');
    expect(page).not.toContain('| Key | Action | Mode |');
  });

  test('adds the mode column when a bind needs it', () => {
    const page = render(
      [findFile, {key: '<leader>fx', mode: ['n', 'x'], desc: 'Visual thing'}],
    );
    expect(page).toContain('| Key | Action | Mode |');
    expect(page).toContain('| `<leader>fx` | Visual thing | n, x |');
  });

  test('fills the mode column for normal-mode binds once it exists', () => {
    const page = render(
      [findFile, {key: '<leader>fx', mode: ['n', 'x'], desc: 'Visual thing'}],
    );
    expect(page).toContain('| `<leader>ff` | Find File | n |');
  });

  test('leaves a blank line before the first group heading', () => {
    const page = render([findFile]);
    expect(page).toContain('\n\n## Find');
  });

  test('escapes a pipe so it cannot break the table', () => {
    const page = render(
      [{key: '<leader>fp', mode: 'n', desc: 'Pipe | through'}],
    );
    expect(page).toContain('Pipe \\| through');
  });

  test('escapes MDX-hostile characters outside code spans', () => {
    const page = render(
      [{key: '<leader>fq', mode: 'n', desc: 'Takes {a} arg'}],
    );
    expect(page).toContain('Takes \\{a\\} arg');
  });

  test('tolerates a missing description', () => {
    const page = render(
      [{key: '<leader>fz', mode: 'n'}],
    );
    expect(page).toContain('| `<leader>fz` |');
  });
});

describe('formatLeader', () => {
  test('names the space key, which is unreadable rendered literally', () => {
    expect(formatLeader(' ')).toBe('<Space>');
  });

  test('passes a printable leader through', () => {
    expect(formatLeader(',')).toBe(',');
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

describe('renderKeybindingsPage leader and which-key framing', () => {
  test('takes the leader from the data rather than hardcoding it', () => {
    expect(render([findFile], register, ',')).toContain('The leader key is `,`.');
  });

  test('renders a space leader as <Space>', () => {
    expect(render([findFile])).toContain('The leader key is `<Space>`.');
  });

  test('tells the reader the which-key popup is the complete reference', () => {
    const page = render([findFile]);
    expect(page).toContain('which-key');
    expect(page).toContain('complete reference');
  });
});
