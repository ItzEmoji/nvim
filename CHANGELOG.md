# Changelog

## [1.1.0](https://github.com/ItzEmoji/nvim/compare/v1.0.0...v1.1.0) (2026-08-01)


### Features

* **clipboard:** add clipboard history with yanky ([7d352a0](https://github.com/ItzEmoji/nvim/commit/7d352a0f910447f538ba77f7c4465d8dc83fff54))
* **clipboard:** reach the system clipboard through leader binds ([e18e4f2](https://github.com/ItzEmoji/nvim/commit/e18e4f2474f0e61e07d3bc9c6ed8ea5792d40143))
* **cmp:** add the LSP signature-help source ([92ef961](https://github.com/ItzEmoji/nvim/commit/92ef9617b6370f855729fcb20a1cbfda089b5519))
* **cmp:** cycle completions with ctrl-j and ctrl-k ([0e78a16](https://github.com/ItzEmoji/nvim/commit/0e78a167d446054e94a4bcb6fc4cb9e83736dc96))
* **cmp:** suggest spelling corrections in the completion menu ([e4aad5b](https://github.com/ItzEmoji/nvim/commit/e4aad5bc00a413f21410e02b6623def53e98cabb))
* **dashboard:** cut the start screen down to two actions ([5e9683a](https://github.com/ItzEmoji/nvim/commit/5e9683a13c5cc801d16de26e8279d87a15fedf83))
* **diagnostics:** show fixes in a float when the cursor rests ([9cd7187](https://github.com/ItzEmoji/nvim/commit/9cd71878f258e5210a74c75b10fc27c83a815ee4))
* **docs:** add offline local search across docs and generated pages ([5632dfe](https://github.com/ItzEmoji/nvim/commit/5632dfea928c528ff7b0facf3aaee09c0219b931))
* **docs:** drop the generated option reference ([1030029](https://github.com/ItzEmoji/nvim/commit/10300297f6b7230583443d8b470f8d32f50f3b76))
* **docs:** extract configured nvf options to JSON ([2213722](https://github.com/ItzEmoji/nvim/commit/2213722330ccde35b7df53e8180a413beb08b530))
* **docs:** extract keybindings instead of every option ([ba19bfb](https://github.com/ItzEmoji/nvim/commit/ba19bfbc8de868a6fbf2ff35d66ebe98f1c7b813))
* **docs:** generate a single keybindings page from vim.keymaps ([6b35379](https://github.com/ItzEmoji/nvim/commit/6b35379bececde19d5ffec40877c1bf0914c3939))
* **docs:** generate option reference pages from extracted JSON ([a4edf64](https://github.com/ItzEmoji/nvim/commit/a4edf6422b65a770edd99d35466a303b136b42ae))
* **docs:** render structured option values as markdown ([5ca7442](https://github.com/ItzEmoji/nvim/commit/5ca7442bea90de9c6edaa20f2c6577f70f61e5c6))
* **docs:** render the option reference with ndg as well ([0fea0be](https://github.com/ItzEmoji/nvim/commit/0fea0bef959a0c7b38096050bce0e896814b9030))
* **docs:** scaffold the Docusaurus site ([b511bcd](https://github.com/ItzEmoji/nvim/commit/b511bcd97c2bacd0924f1f7e1760d52b3456d85f))
* **git:** show blame for the current line only ([350ed8c](https://github.com/ItzEmoji/nvim/commit/350ed8cae860f27dffcb6a4d37b653671376e81a))
* **motion:** add flash.nvim for in-buffer jumps ([8007e55](https://github.com/ItzEmoji/nvim/commit/8007e551683f7609b603369a44e90ce81526e272))
* **motion:** add precognition for motion discovery ([68f1080](https://github.com/ItzEmoji/nvim/commit/68f1080cde97bda02a6a9dbd017e853214700723))
* **options:** add editor quality-of-life defaults ([8571063](https://github.com/ItzEmoji/nvim/commit/857106389bf4ad8baa05436cb870a564a7c7a7f8))
* **snippets:** add luasnip with friendly-snippets ([e1facb4](https://github.com/ItzEmoji/nvim/commit/e1facb492d92199c1ac164a0fd8fdaf772d1a428))
* **snippets:** scope snippet filetypes to the enabled languages ([d20bda3](https://github.com/ItzEmoji/nvim/commit/d20bda3a52642600c25cbc09193a3e34f7b80790))
* **spellcheck:** enable spellchecking with Nix-provided dictionaries ([139c121](https://github.com/ItzEmoji/nvim/commit/139c121c72e36bc6d842b477d7d5401039837421))
* **ui:** add folding via nvim-ufo ([22e496d](https://github.com/ItzEmoji/nvim/commit/22e496dd5471ec23c302664b9f9a1d71ee115009))
* **ui:** highlight other uses of the word under the cursor ([f44787c](https://github.com/ItzEmoji/nvim/commit/f44787c26dd248527664a1cca4d47eac8b63f8b7))


### Bug Fixes

* add git integration ([d2a7024](https://github.com/ItzEmoji/nvim/commit/d2a7024f7e37bec23b274e0dc91493e0cb18ecd8))
* add markdown support ([08c431b](https://github.com/ItzEmoji/nvim/commit/08c431b3f44d06bcfc602c8254f59a1d7c09b17a))
* add nvim-colorizer ([0c062b5](https://github.com/ItzEmoji/nvim/commit/0c062b5ab4124688c2d262744dee25086f220b44))
* add which-key descriptions ([41929cc](https://github.com/ItzEmoji/nvim/commit/41929cc31cb824ca0129ee5288137de5bc85dec9))
* **cmp:** register the LSP source when the server attaches ([11af662](https://github.com/ItzEmoji/nvim/commit/11af662d039622c3aec9b510c004d37b2a52f556))
* **cmp:** remove luasnip source with no plugin behind it ([821c7db](https://github.com/ItzEmoji/nvim/commit/821c7dbdfb5a2d762a62f2b4dd7b13d9dcc0b14c))
* **docs:** annotate the backtick-run match so typecheck passes ([900da0c](https://github.com/ItzEmoji/nvim/commit/900da0cb5700ed54d282ac7e22dfaa71d30330d1))
* **docs:** escape descriptions only outside code spans, quote scalar defaults ([d981c9a](https://github.com/ItzEmoji/nvim/commit/d981c9a11bd3abc981eb0368dd6d117e188fe5e0))
* **docs:** escape Nix metacharacters in generated value text ([56d360a](https://github.com/ItzEmoji/nvim/commit/56d360a2a3e08c01b67bdd79b9206bb911e841d4))
* **docs:** harden keymap extraction against silent data corruption ([f917e5f](https://github.com/ItzEmoji/nvim/commit/f917e5f403753c6120fb08ada081151f36ac7c9a))
* **docs:** leave hyphenated Nix attribute names unquoted ([79ad7ef](https://github.com/ItzEmoji/nvim/commit/79ad7ef8530bf8c191b9aabb6d8d463554fe0e79))
* **docs:** make code blocks in option-meta span full width ([e9ebade](https://github.com/ItzEmoji/nvim/commit/e9ebadea495faa357e036b9082c8da193011ecc9))
* **docs:** make the schemaVersion guard reachable and testable ([d9bdebb](https://github.com/ItzEmoji/nvim/commit/d9bdebbf771a291b171b258565a55e02d094ce32))
* **docs:** refuse to guess a missing leader in render-keymaps ([f1f8272](https://github.com/ItzEmoji/nvim/commit/f1f82720d71034327782b157bc799e9f50c826cb))
* **docs:** render multiline option defaults as their own code block ([181bd1a](https://github.com/ItzEmoji/nvim/commit/181bd1a2a4440514dc173cf237e1a3eea6bedf60))
* **docs:** render option defaults as structured data ([da34823](https://github.com/ItzEmoji/nvim/commit/da34823c5314cc9e2a541c36d4360fb1847cad12))
* general things ([a1c527c](https://github.com/ItzEmoji/nvim/commit/a1c527c071e82a5e884e6b3752e59ad072ccdd23))
* install whichKey ([07a6f3a](https://github.com/ItzEmoji/nvim/commit/07a6f3af60116f3893b21c37640a277cd13769dd))
* **keybinds:** gate the Trouble bindings on the language layer ([d69f31a](https://github.com/ItzEmoji/nvim/commit/d69f31a565216012792168ac9876e3d12731615e))
* remove ndg as it's not required ([70830d2](https://github.com/ItzEmoji/nvim/commit/70830d2ebc4ee4ce39e49451ca8500ac53c3e265))
* **snacks:** drop no-op styles option ([bd971db](https://github.com/ItzEmoji/nvim/commit/bd971db660b0d3b4fa56705ade38ecc1ddcbe27f))
* **snacks:** pass explorer layout as an attrset ([1249121](https://github.com/ItzEmoji/nvim/commit/124912145afeed2260bea65c512b313ba87a45fd))


### Reverts

* **cmp:** drop the spelling source and hover float ([e904340](https://github.com/ItzEmoji/nvim/commit/e904340e8624348968ff0bcd4cdea9f3eb7e6a7a))
* **motion:** drop precognition ([9bc8ea0](https://github.com/ItzEmoji/nvim/commit/9bc8ea04a6e31771923f3ff9203b0a2d2773a642))

## 1.0.0 (2026-07-25)


### Bug Fixes

* colorscheme and eval warning ([#2](https://github.com/ItzEmoji/nvim/issues/2)) ([9795e11](https://github.com/ItzEmoji/nvim/commit/9795e11a7f12958b2e8133cef2d4578efd680d9b))
* refactor release workflow ([66022c7](https://github.com/ItzEmoji/nvim/commit/66022c736bc82574c52894fc742db4a0a52ad961))
* refactor release workflow ([34a77bc](https://github.com/ItzEmoji/nvim/commit/34a77bca6b09c08171e8fb67d484c4dac9756621))
