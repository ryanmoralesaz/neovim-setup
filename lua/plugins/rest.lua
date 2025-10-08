return {
  "mistweaverco/kulala.nvim",
  config = function()
    require("kulala").setup()
    
    -- Keybindings
    vim.keymap.set('n', '<leader>rr', require('kulala').run, { desc = "Run request" })
    vim.keymap.set('n', '<leader>rt', require('kulala').toggle_view, { desc = "Toggle view" })
  end,
}
