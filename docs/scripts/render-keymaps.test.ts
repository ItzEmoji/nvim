import {afterEach, beforeEach, describe, expect, test} from 'bun:test';
import {mkdtempSync, readFileSync, rmSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {writeKeybindings, type KeymapsFile} from './render-keymaps';
import type {Keymap} from './keymaps';

const findFile: Keymap = {
  key: '<leader>ff',
  mode: 'n',
  desc: 'Find File',
};

let dir: string;
let outPath: string;

beforeEach(() => {
  dir = mkdtempSync(join(tmpdir(), 'render-keymaps-test-'));
  outPath = join(dir, 'keybindings.mdx');
});

afterEach(() => {
  rmSync(dir, {recursive: true, force: true});
});

function input(overrides: Partial<KeymapsFile> = {}): KeymapsFile {
  return {
    schemaVersion: 1,
    leader: ' ',
    groups: {'<leader>f': 'Find'},
    keymaps: [findFile],
    ...overrides,
  };
}

describe('writeKeybindings', () => {
  test('writes the rendered page when there are keymaps', () => {
    const wrote = writeKeybindings(input(), outPath);
    expect(wrote).toBe(true);

    const content = readFileSync(outPath, 'utf8');
    expect(content).toContain('## Find');
    expect(content).toContain('| `<leader>ff` | Find File |');
  });

  test('returns false and writes nothing for an empty keymaps array', () => {
    const wrote = writeKeybindings(input({keymaps: []}), outPath);
    expect(wrote).toBe(false);
    expect(() => readFileSync(outPath, 'utf8')).toThrow();
  });

  test('throws rather than guessing a leader when leader is missing', () => {
    const {leader: _leader, ...rest} = input();
    // Casting past the type system: simulates a keymaps.json that omits the
    // leader field, which is exactly the runtime case being guarded against.
    const bad = rest as KeymapsFile;
    expect(() => writeKeybindings(bad, outPath)).toThrow(/leader/);
  });

  test('uses the leader from the input instead of a hardcoded space', () => {
    writeKeybindings(input({leader: ','}), outPath);
    const content = readFileSync(outPath, 'utf8');
    expect(content).toContain('The leader key is `,`.');
  });
});
