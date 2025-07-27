return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      transparent = true,
      theme = "dragon", -- opciones: "wave", "dragon", "lotus"
      background = {
        dark = "wave",
        light = "lotus"
      },
    })
    vim.cmd("colorscheme kanagawa")
  end,
}

