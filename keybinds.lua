-- ~/.config/nvim/lua/config/keybinds.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local Snacks = require("snacks") -- Access snacks.nvim API

-- Snacks.nvim keybindings
local function setup_snacks_keybinds()
  -- Top Pickers & Explorer
  map("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
  map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  map("n", "<leader>/", function() Snacks.picker.grep({ prompt = "> " }) end, { desc = "Grep" })
  map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
  map("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
  map("n", "<leader>ee", function() Snacks.explorer() end, { desc = "File Explorer" })

  -- Find
  map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
  map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
  map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
  map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
  map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })

  -- Git
  map("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
  map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
  map("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
  map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
  map("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
  map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
  map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
  map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })

  -- Grep
  map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
  map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
  map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
  map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })

  -- Search
  map("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
  map("n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search History" })
  map("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
  map("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
  map("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
  map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
  map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
  map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
  map("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
  map("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
  map("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
  map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
  map("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
  map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
  map("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
  map("n", "<leader>sp", function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
  map("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
  map("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
  map("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
  map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

  -- LSP
  map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
  map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
  map("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
  map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
  map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
  map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
  map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
  map("n", "<leader>fm", vim.lsp.buf.format, { buffer = bufnr, desc = "Format file with LSP" })


  -- Other
  map("n", "<leader>z", function() Snacks.zen() end, { desc = "Toggle Zen Mode" })
  map("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Toggle Zoom" })
  map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
  map("n", "<leader>S", function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
  map("n", "<leader>n", function() Snacks.notifier.show_history() end, { desc = "Notification History" })
  map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
  map("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
  map({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
  map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
  map("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
  map("n", "<leader>tr", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
  map("n", "<c-_>", function() Snacks.terminal() end, { desc = "which_key_ignore" })
  map({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
  map({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
  map("n", "<leader>th", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
  map("n", "<leader>N", function()
    Snacks.win({
      file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
      width = 0.6,
      height = 0.6,
      wo = {
        spell = false,
        wrap = false,
        signcolumn = "yes",
        statuscolumn = " ",
        conceallevel = 3,
      },
    })
  end, { desc = "Neovim News" })
end

-- Toggle keybindings (from init)
local function setup_toggle_keybinds()
  Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  Snacks.toggle.diagnostics():map("<leader>ud")
  Snacks.toggle.line_number():map("<leader>ul")
  Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
  Snacks.toggle.treesitter():map("<leader>uT")
  Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
  Snacks.toggle.inlay_hints():map("<leader>uh")
  Snacks.toggle.indent():map("<leader>ug")
  Snacks.toggle.dim():map("<leader>uD")
end
local function setup_mini_keybinds()
  map("n", "<leader>gp", "<cmd>lua require('mini.splitjoin').toggle()<cr>", { desc = "Toggle Split/Join" })
end
-- Custom keybindings (add your own here)
local function setup_custom_keybinds()
  -- Example: Reload config
  map("n", "<leader>r", ":source ~/.config/nvim/init.lua<cr>", { desc = "Reload Config" })
  -- Add more as needed...
end

-- Execute all keybind setups
local function setup_all_keybinds()
  setup_snacks_keybinds()
  setup_toggle_keybinds()
  setup_mini_keybinds()
  setup_custom_keybinds()
end

-- Run the setup
setup_all_keybinds()

-- Return a module for dynamic additions
return {
  add_keybind = function(mode, lhs, rhs, options)
    map(mode, lhs, rhs, options or opts)
  end,
}
