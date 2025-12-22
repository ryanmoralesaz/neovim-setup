return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "text" },  -- Only load for markdown and text files
  config = function()
    -- Use | for corners (standard markdown)
    vim.g.table_mode_corner = '|'
    
    -- Keybindings
    vim.keymap.set('n', '<leader>tm', ':TableModeToggle<CR>', { desc = "Toggle Table Mode" })
    vim.keymap.set('n', '<leader>tr', ':TableModeRealign<CR>', { desc = "Realign Table" })
    
    -- Optional: Auto-enable for markdown files (uncomment if you want)
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "markdown",
    --   callback = function()
    --     vim.cmd("TableModeEnable")
    --   end,
    -- })
  end,
}
