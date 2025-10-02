return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "catppuccin",
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                icons_enabled = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {},
                lualine_x = { "filetype" },
                lualine_y = {},
                lualine_z = { "location" }
            }
        })
    end
}

