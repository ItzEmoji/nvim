{ pkgs, lib, ... }:
{
  vim = {
    keymaps = [
      # -----------------------------------------------------------------------
      # -- Snacks.nvim Keybindings
      # -----------------------------------------------------------------------

      # -- Top Pickers & Explorer
      {
        key = "<leader><space>";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.smart()<CR>";
      }
      {
        key = "<leader>,";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.buffers()<CR>";
      }
      {
        key = "<leader>/";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.grep({ prompt = '> ' })<CR>";
      }
      {
        key = "<leader>:";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.command_history()<CR>";
      }
      {
        key = "<leader>n";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.notifications()<CR>";
      }
      {
        key = "<leader>ee";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').explorer()<CR>";
      }

      # -- Find
      {
        key = "<leader>fb";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.buffers()<CR>";
      }
      {
        key = "<leader>fc";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.files({ cwd = vim.fn.stdpath('config') })<CR>";
      }
      {
        key = "<leader>ff";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.files()<CR>";
      }
      {
        key = "<leader>fg";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.git_files()<CR>";
      }
      {
        key = "<leader>fp";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.projects()<CR>";
      }
      {
        key = "<leader>fr";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.recent()<CR>";
      }

      # -- Git
      {
        key = "<leader>gb";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.git_branches()<CR>";
      }
      {
        key = "<leader>gl";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.git_log()<CR>";
      }
      {
        key = "<leader>gL";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.git_log_line()<CR>";
      }
      {
        key = "<leader>gs";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.git_status()<CR>";
      }
      {
        key = "<leader>gS";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.git_stash()<CR>";
      }
      {
        key = "<leader>gd";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.git_diff()<CR>";
      }
      {
        key = "<leader>gf";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.git_log_file()<CR>";
      }
      {
        key = "<leader>gg";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').lazygit()<CR>";
      }

      # -- Grep
      {
        key = "<leader>sb";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.lines()<CR>";
      }
      {
        key = "<leader>sB";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.grep_buffers()<CR>";
      }
      {
        key = "<leader>sg";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.grep()<CR>";
      }
      {
        key = "<leader>sw";
        mode = [
          "n"
          "x"
        ];
        silent = true;
        action = "<cmd>lua require('snacks').picker.grep_word()<CR>";
      }

      # -- Search
      {
        key = "<leader>s\"";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.registers()<CR>";
      }
      {
        key = "<leader>s/";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.search_history()<CR>";
      }
      {
        key = "<leader>sa";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.autocmds()<CR>";
      }
      {
        key = "<leader>sc";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.command_history()<CR>";
      }
      {
        key = "<leader>sC";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.commands()<CR>";
      }
      {
        key = "<leader>sd";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.diagnostics()<CR>";
      }
      {
        key = "<leader>sD";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.diagnostics_buffer()<CR>";
      }
      {
        key = "<leader>sh";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.help()<CR>";
      }
      {
        key = "<leader>sH";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.highlights()<CR>";
      }
      {
        key = "<leader>si";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.icons()<CR>";
      }
      {
        key = "<leader>sj";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.jumps()<CR>";
      }
      {
        key = "<leader>sk";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.keymaps()<CR>";
      }
      {
        key = "<leader>sl";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.loclist()<CR>";
      }
      {
        key = "<leader>sm";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.marks()<CR>";
      }
      {
        key = "<leader>sM";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.man()<CR>";
      }
      {
        key = "<leader>sp";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.lazy()<CR>";
      }
      {
        key = "<leader>sq";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.qflist()<CR>";
      }
      {
        key = "<leader>sR";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.resume()<CR>";
      }
      {
        key = "<leader>su";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.undo()<CR>";
      }
      {
        key = "<leader>uC";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.colorschemes()<CR>";
      }

      # -- LSP
      {
        key = "gd";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.lsp_definitions()<CR>";
      }
      {
        key = "gD";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.lsp_declarations()<CR>";
      }
      {
        key = "gr";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.lsp_references()<CR>";
      }
      {
        key = "gI";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.lsp_implementations()<CR>";
      }
      {
        key = "gy";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.lsp_type_definitions()<CR>";
      }
      {
        key = "<leader>ss";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.lsp_symbols()<CR>";
      }
      {
        key = "<leader>sS";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.lsp_workspace_symbols()<CR>";
      }
      {
        key = "<leader>fm";
        mode = "n";
        silent = true;
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
      }

      # -- Other
      {
        key = "<leader>z";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').zen()<CR>";
      }
      {
        key = "<leader>Z";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').zen.zoom()<CR>";
      }
      {
        key = "<leader>.";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').scratch()<CR>";
      }
      {
        key = "<leader>S";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').scratch.select()<CR>";
      }
      # Note: <leader>n was duplicated. The picker.notifications() binding from above takes precedence.
      # { key = "<leader>n"; mode = "n"; silent = true; action = "<cmd>lua require('snacks').notifier.show_history()<CR>"; }
      {
        key = "<leader>bd";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').bufdelete()<CR>";
      }
      {
        key = "<leader>cR";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').rename.rename_file()<CR>";
      }
      {
        key = "<leader>gB";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>lua require('snacks').gitbrowse()<CR>";
      }
      # Note: <leader>gg is duplicated, keeping the first one.
      # { key = "<leader>gg"; mode = "n"; silent = true; action = "<cmd>lua require('snacks').lazygit()<CR>"; }
      {
        key = "<leader>un";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').notifier.hide()<CR>";
      }
      {
        key = "<leader>tr";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').terminal()<CR>";
      }
      {
        key = "<c-_>";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').terminal()<CR>";
      }
      {
        key = "]]";
        mode = [
          "n"
          "t"
        ];
        silent = true;
        action = "<cmd>lua require('snacks').words.jump(vim.v.count1)<CR>";
      }
      {
        key = "[[";
        mode = [
          "n"
          "t"
        ];
        silent = true;
        action = "<cmd>lua require('snacks').words.jump(-vim.v.count1)<CR>";
      }
      {
        key = "<leader>th";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').picker.colorschemes()<CR>";
      }
      {
        key = "<leader>N";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').win({ file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1], width = 0.6, height = 0.6, wo = { spell = false, wrap = false, signcolumn = 'yes', statuscolumn = ' ', conceallevel = 3 } })<CR>";
      }

      # -----------------------------------------------------------------------
      # -- Toggle Keybindings
      # -----------------------------------------------------------------------
      {
        key = "<leader>us";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.option('spell', { name = 'Spelling' })()<CR>";
      }
      {
        key = "<leader>uw";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.option('wrap', { name = 'Wrap' })()<CR>";
      }
      {
        key = "<leader>uL";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.option('relativenumber', { name = 'Relative Number' })()<CR>";
      }
      {
        key = "<leader>ud";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.diagnostics()()<CR>";
      }
      {
        key = "<leader>ul";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.line_number()()<CR>";
      }
      {
        key = "<leader>uc";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.option('conceallevel', { off = 0, on = 2 })()<CR>";
      }
      {
        key = "<leader>uT";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.treesitter()()<CR>";
      }
      {
        key = "<leader>ub";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' })()<CR>";
      }
      {
        key = "<leader>uh";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.inlay_hints()()<CR>";
      }
      {
        key = "<leader>ug";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.indent()()<CR>";
      }
      {
        key = "<leader>uD";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('snacks').toggle.dim()()<CR>";
      }

      # -----------------------------------------------------------------------
      # -- Mini.nvim Keybindings
      # -----------------------------------------------------------------------
      {
        key = "<leader>gp";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('mini.splitjoin').toggle()<CR>";
      }

      # -----------------------------------------------------------------------
      # -- Custom Keybindings
      # -----------------------------------------------------------------------
      {
        key = "<leader>r";
        mode = "n";
        silent = true;
        action = ":source ~/.config/nvim/init.lua<CR>";
      }

      # -----------------------------------------------------------------------
      # -- Trouble
      # -----------------------------------------------------------------------
      {
        key = "<leader>xx";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble diagnostics toggle<cr>";
      }
      {
        key = "<leader>xX";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      }
      {
        key = "<leader>cs";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble symbols toggle focus=false<cr>";
      }
      {
        key = "<leader>cl";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      }
      {
        key = "<leader>xL";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble loclist toggle<cr>";
      }
      {
        key = "<leader>xQ";
        mode = "n";
        silent = true;
        action = "<cmd>Trouble qflist toggle<cr>";
      }

    ];
  };
}
