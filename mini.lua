return {
   "echasnovski/mini.nvim",
   config = function()
     require("mini.pairs").setup()
     require('mini.comment').setup()
     require('mini.surround').setup()
     require("mini.splitjoin").setup({})
     require("mini.move").setup()
     require("mini.sessions").setup()
   end,
 }
