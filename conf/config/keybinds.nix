{
  pkgs,
  lib,
  enabledLanguages,
  ...
}:
let
  inherit (lib.lists) optionals;

  # Trouble ships with the language layer, so with no languages enabled its
  # `:Trouble` command does not exist and these binds would fail with E492.
  hasLanguages = enabledLanguages != [ ];

  # `<cmd>lua require('snacks').<call><CR>` — the shape of nearly every bind below.
  snacks = call: "<cmd>lua require('snacks').${call}<CR>";

  # Toggles expose a factory, hence the trailing `()`.
  toggle = call: snacks "toggle.${call}()";
  toggleOpt = opt: opts: toggle "option('${opt}', ${opts})";

  # mode -> key -> action -> desc. `desc` is what which-key displays.
  mkMap = mode: key: action: desc: {
    inherit
      mode
      key
      action
      desc
      ;
    silent = true;
  };

  nmap = mkMap "n";

  # `<Plug>` targets are themselves mappings, so they must be resolved
  # recursively. `noremap = true` (nvf's default) would silently break them.
  plugMap =
    mode: key: plug: desc:
    (mkMap mode key "<Plug>(${plug})" desc) // { noremap = false; };

  # Same as plugMap, but runs the `<Plug>` target against an explicit register.
  # Yanky reads `v:register`, so prefixing `"+` sends the operation to the
  # system clipboard while the bare mappings stay on Neovim's own registers.
  plugMapReg =
    mode: key: reg: plug: desc:
    (mkMap mode key ''"${reg}<Plug>(${plug})'' desc) // { noremap = false; };

  newsPopup = snacks "win({ file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1], width = 0.6, height = 0.6, wo = { spell = false, wrap = false, signcolumn = 'yes', statuscolumn = ' ', conceallevel = 3 } })";
in
{
  vim = {
    keymaps = [
      # -- Top pickers & explorer ---------------------------------------------
      (nmap "<leader><space>" (snacks "picker.smart()") "Smart Find Files")
      (nmap "<leader>," (snacks "picker.buffers()") "Buffers")
      (nmap "<leader>/" (snacks "picker.grep({ prompt = '> ' })") "Grep Project")
      (nmap "<leader>:" (snacks "picker.command_history()") "Command History")
      (nmap "<leader>n" (snacks "picker.notifications()") "Notification History")
      (nmap "<leader>ee" (snacks "explorer()") "File Explorer")

      # -- Find ---------------------------------------------------------------
      (nmap "<leader>fb" (snacks "picker.buffers()") "Find Buffer")
      (nmap "<leader>fc" (snacks "picker.files({ cwd = vim.fn.stdpath('config') })") "Find Config File")
      (nmap "<leader>ff" (snacks "picker.files()") "Find File")
      (nmap "<leader>fg" (snacks "picker.git_files()") "Find Git File")
      (nmap "<leader>fp" (snacks "picker.projects()") "Find Project")
      (nmap "<leader>fr" (snacks "picker.recent()") "Recent Files")
      (nmap "<leader>fm" "<cmd>lua vim.lsp.buf.format()<CR>" "Format Buffer (LSP)")

      # -- Git ----------------------------------------------------------------
      (nmap "<leader>gg" (snacks "lazygit()") "Lazygit")
      (nmap "<leader>gb" (snacks "picker.git_branches()") "Git Branches")
      (nmap "<leader>gl" (snacks "picker.git_log()") "Git Log")
      (nmap "<leader>gL" (snacks "picker.git_log_line()") "Git Log (Current Line)")
      (nmap "<leader>gf" (snacks "picker.git_log_file()") "Git Log (Current File)")
      (nmap "<leader>gs" (snacks "picker.git_status()") "Git Status")
      (nmap "<leader>gS" (snacks "picker.git_stash()") "Git Stash")
      (nmap "<leader>gd" (snacks "picker.git_diff()") "Git Diff (Hunks)")
      (nmap "<leader>gp" "<cmd>lua require('mini.splitjoin').toggle()<CR>" "Split/Join Arguments")
      (mkMap [ "n" "v" ] "<leader>gB" (snacks "gitbrowse()") "Open in Browser (Git Remote)")

      # -- Grep ---------------------------------------------------------------
      (nmap "<leader>sb" (snacks "picker.lines()") "Grep Buffer Lines")
      (nmap "<leader>sB" (snacks "picker.grep_buffers()") "Grep Open Buffers")
      (nmap "<leader>sg" (snacks "picker.grep()") "Grep Project")
      (mkMap [ "n" "x" ] "<leader>sw" (snacks "picker.grep_word()") "Grep Word Under Cursor")

      # -- Search -------------------------------------------------------------
      (nmap "<leader>s\"" (snacks "picker.registers()") "Registers")
      (nmap "<leader>s/" (snacks "picker.search_history()") "Search History")
      (nmap "<leader>sa" (snacks "picker.autocmds()") "Autocommands")
      (nmap "<leader>sc" (snacks "picker.command_history()") "Command History")
      (nmap "<leader>sC" (snacks "picker.commands()") "Commands")
      (nmap "<leader>sd" (snacks "picker.diagnostics()") "Diagnostics (Workspace)")
      (nmap "<leader>sD" (snacks "picker.diagnostics_buffer()") "Diagnostics (Buffer)")
      (nmap "<leader>sh" (snacks "picker.help()") "Help Pages")
      (nmap "<leader>sH" (snacks "picker.highlights()") "Highlight Groups")
      (nmap "<leader>si" (snacks "picker.icons()") "Icons")
      (nmap "<leader>sj" (snacks "picker.jumps()") "Jumplist")
      (nmap "<leader>sk" (snacks "picker.keymaps()") "Keymaps")
      (nmap "<leader>sl" (snacks "picker.loclist()") "Location List")
      (nmap "<leader>sm" (snacks "picker.marks()") "Marks")
      (nmap "<leader>sM" (snacks "picker.man()") "Man Pages")
      (nmap "<leader>sp" (snacks "picker.lazy()") "Plugin Specs")
      (nmap "<leader>sq" (snacks "picker.qflist()") "Quickfix List")
      (nmap "<leader>sR" (snacks "picker.resume()") "Resume Last Picker")
      (nmap "<leader>su" (snacks "picker.undo()") "Undo History")
      (nmap "<leader>ss" (snacks "picker.lsp_symbols()") "LSP Symbols (Buffer)")
      (nmap "<leader>sS" (snacks "picker.lsp_workspace_symbols()") "LSP Symbols (Workspace)")

      # -- LSP navigation -----------------------------------------------------
      (nmap "gd" (snacks "picker.lsp_definitions()") "Goto Definition")
      (nmap "gD" (snacks "picker.lsp_declarations()") "Goto Declaration")
      (nmap "gr" (snacks "picker.lsp_references()") "References")
      (nmap "gI" (snacks "picker.lsp_implementations()") "Goto Implementation")
      (nmap "gy" (snacks "picker.lsp_type_definitions()") "Goto Type Definition")
      (mkMap [ "n" "t" ] "]]" (snacks "words.jump(vim.v.count1)") "Next Reference")
      (mkMap [ "n" "t" ] "[[" (snacks "words.jump(-vim.v.count1)") "Previous Reference")

      # -- Code ---------------------------------------------------------------
      (nmap "<leader>cR" (snacks "rename.rename_file()") "Rename File")

      # -- Buffers ------------------------------------------------------------
      (nmap "<leader>bd" (snacks "bufdelete()") "Delete Buffer")

      # -- Folding (ufo) ------------------------------------------------------
      # ufo keeps its own fold state, so the built-in zR/zM need redirecting.
      (nmap "zR" "<cmd>lua require('ufo').openAllFolds()<CR>" "Open All Folds")
      (nmap "zM" "<cmd>lua require('ufo').closeAllFolds()<CR>" "Close All Folds")

      # -- Clipboard (yanky) --------------------------------------------------
      # `y` and `p` behave exactly as before, on Neovim's own registers, so
      # deletes and changes never clobber the system clipboard.
      (plugMap [ "n" "x" ] "y" "YankyYank" "Yank")
      (plugMap [ "n" "x" ] "p" "YankyPutAfter" "Paste After")
      (plugMap [ "n" "x" ] "P" "YankyPutBefore" "Paste Before")

      # The leader variants are the only things that cross into the system
      # clipboard. Needs a provider on PATH — see conf/clipboard.nix.
      (plugMapReg [ "n" "x" ] "<leader>y" "+" "YankyYank" "Yank to System Clipboard")
      (plugMapReg [ "n" "x" ] "<leader>p" "+" "YankyPutAfter" "Paste After from System Clipboard")
      (plugMapReg [ "n" "x" ] "<leader>P" "+" "YankyPutBefore" "Paste Before from System Clipboard")

      # `Y` yanks to end of line, so <leader>Y is the natural counterpart.
      (mkMap "n" "<leader>Y" ''"+y$'' "Yank to End of Line to System Clipboard")

      # Straight after a paste, cycle it through earlier clipboard entries.
      (plugMap "n" "<c-n>" "YankyNextEntry" "Cycle to Newer Clipboard Entry")
      (plugMap "n" "<c-p>" "YankyPreviousEntry" "Cycle to Older Clipboard Entry")

      (nmap "<leader>fy" "<cmd>YankyRingHistory<CR>" "Clipboard History")

      # -- Terminal & theme ---------------------------------------------------
      (nmap "<leader>tr" (snacks "terminal()") "Toggle Terminal")
      (nmap "<c-_>" (snacks "terminal()") "Toggle Terminal")
      (nmap "<leader>th" (snacks "picker.colorschemes()") "Pick Colorscheme")

      # -- UI toggles ---------------------------------------------------------
      (nmap "<leader>us" (toggleOpt "spell" "{ name = 'Spelling' }") "Toggle Spelling")
      (nmap "<leader>uw" (toggleOpt "wrap" "{ name = 'Wrap' }") "Toggle Wrap")
      (nmap "<leader>ul" (toggle "line_number") "Toggle Line Numbers")
      (nmap "<leader>uL" (toggleOpt "relativenumber" "{ name = 'Relative Number' }")
        "Toggle Relative Numbers"
      )
      (nmap "<leader>ud" (toggle "diagnostics") "Toggle Diagnostics")
      (nmap "<leader>uc" (toggleOpt "conceallevel" "{ off = 0, on = 2 }") "Toggle Conceal")
      (nmap "<leader>uT" (toggle "treesitter") "Toggle Treesitter Highlight")
      (nmap "<leader>ub"
        (toggleOpt "background" "{ off = 'light', on = 'dark', name = 'Dark Background' }")
        "Toggle Dark Background"
      )
      (nmap "<leader>uh" (toggle "inlay_hints") "Toggle Inlay Hints")
      (nmap "<leader>ug" (toggle "indent") "Toggle Indent Guides")
      (nmap "<leader>uD" (toggle "dim") "Toggle Dimming")
      (nmap "<leader>un" (snacks "notifier.hide()") "Dismiss Notifications")
      (nmap "<leader>uC" (snacks "picker.colorschemes()") "Pick Colorscheme")

      # -- Misc ---------------------------------------------------------------
      (nmap "<leader>z" (snacks "zen()") "Toggle Zen Mode")
      (nmap "<leader>Z" (snacks "zen.zoom()") "Toggle Zoom")
      (nmap "<leader>." (snacks "scratch()") "Toggle Scratch Buffer")
      (nmap "<leader>S" (snacks "scratch.select()") "Select Scratch Buffer")
      (nmap "<leader>N" newsPopup "Neovim News")
      (nmap "<leader>r" ":source ~/.config/nvim/init.lua<CR>" "Reload Config")
    ]
    ++ optionals hasLanguages [
      # -- Code (Trouble) -----------------------------------------------------
      (nmap "<leader>cs" "<cmd>Trouble symbols toggle focus=false<cr>" "Symbol Outline (Trouble)")
      (nmap "<leader>cl" "<cmd>Trouble lsp toggle focus=false win.position=right<cr>"
        "LSP Definitions & References (Trouble)"
      )

      # -- Trouble / diagnostics ----------------------------------------------
      (nmap "<leader>xx" "<cmd>Trouble diagnostics toggle<cr>" "Diagnostics (Workspace)")
      (nmap "<leader>xX" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" "Diagnostics (Buffer)")
      (nmap "<leader>xL" "<cmd>Trouble loclist toggle<cr>" "Location List")
      (nmap "<leader>xQ" "<cmd>Trouble qflist toggle<cr>" "Quickfix List")
    ];

    binds.whichKey = {
      enable = true;

      # Group labels for the prefixes used above.
      register = {
        "<leader>b" = "Buffer";
        "<leader>c" = "Code";
        "<leader>e" = "Explorer";
        "<leader>f" = "Find";
        "<leader>g" = "Git";
        "<leader>s" = "Search / Grep";
        "<leader>t" = "Terminal / Theme";
        "<leader>u" = "UI Toggles";
      }
      // lib.optionalAttrs hasLanguages {
        "<leader>x" = "Diagnostics / Lists";
      };
    };
  };
}
