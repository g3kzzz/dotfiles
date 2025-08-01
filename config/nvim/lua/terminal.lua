-- ~/.config/nvim/lua/terminal.lua
local M = {}

function M.setup()
  vim.api.nvim_create_user_command("Term", function()
    vim.cmd("botright split")
    vim.cmd("resize 12")
    vim.cmd("term")
    vim.cmd("startinsert")
  end, {})

  vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = true })
    end,
  })
end

return M
