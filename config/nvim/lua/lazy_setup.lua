-- 🧠 Lazy plugin manager setup
require("lazy").setup({
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("NeoSolarized").setup({
        style = "dark",
        transparent = true,
        terminal_colors = true,
        enable_italics = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = { bold = true },
          variables = {},
          string = { italic = true },
          underline = true,
          undercurl = true,
        },
      })
      vim.cmd([[colorscheme NeoSolarized]])
    end,
  },

  -- Lualine (opcional)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "NeoSolarized"
        }
      })
    end,
  },
})
