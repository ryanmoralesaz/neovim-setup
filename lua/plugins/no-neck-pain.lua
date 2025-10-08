return {
  "shortcuts/no-neck-pain.nvim",
  config = function()
    require("no-neck-pain").setup({
      width = 100,  -- Width of your code area
    })
    
    -- Optional: keybinding to toggle
    vim.keymap.set('n', '<leader>np', ':NoNeckPain<CR>', { desc = "Toggle No Neck Pain" })
  end
}
