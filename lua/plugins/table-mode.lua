return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "text" },  -- Only load for markdown and text files
  config = function()
    -- Use | for corners (standard markdown)
    vim.g.table_mode_corner = '|'
    
    -- Keybindings
    vim.keymap.set('n', '<leader>tm', ':TableModeToggle<CR>', { desc = "Toggle Table Mode" })
    vim.keymap.set('n', '<leader>tr', ':TableModeRealign<CR>', { desc = "Realign Table" })
    
    -- Cell navigation with Tab (in insert mode, inside tables)
    vim.keymap.set('i', '<Tab>', function()
      -- Check if we're in a table (line contains |)
      local line = vim.api.nvim_get_current_line()
      if line:match('|') then
        -- Search forward for next |
        vim.fn.search('|', 'W')
        return '<Right>'
      else
        return '<Tab>'
      end
    end, { expr = true, silent = true })
    
    vim.keymap.set('i', '<S-Tab>', function()
      local line = vim.api.nvim_get_current_line()
      if line:match('|') then
        -- Search backward for previous |
        vim.fn.search('|', 'bW')
        return '<Right>'
      else
        return '<S-Tab>'
      end
    end, { expr = true, silent = true })
    
    -- Optional: Auto-enable for markdown files (uncomment if you want)
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "markdown",
    --   callback = function()
    --     vim.cmd("TableModeEnable")
    --   end,
    -- })
  end,
}return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "text" },  -- Only load for markdown and text files
  config = function()
    -- Use | for corners (standard markdown)
    vim.g.table_mode_corner = '|'
    
    -- Keybindings
    vim.keymap.set('n', '<leader>tm', ':TableModeToggle<CR>', { desc = "Toggle Table Mode" })
    vim.keymap.set('n', '<leader>tr', ':TableModeRealign<CR>', { desc = "Realign Table" })
    
    -- Cell navigation with Tab (in insert mode, inside tables)
    vim.keymap.set('i', '<Tab>', function()
      -- Check if we're in a table (line contains |)
      local line = vim.api.nvim_get_current_line()
      if line:match('|') then
        -- Search forward for next |
        vim.fn.search('|', 'W')
        return '<Right>'
      else
        return '<Tab>'
      end
    end, { expr = true, silent = true })
    
    vim.keymap.set('i', '<S-Tab>', function()
      local line = vim.api.nvim_get_current_line()
      if line:match('|') then
        -- Search backward for previous |
        vim.fn.search('|', 'bW')
        return '<Right>'
      else
        return '<S-Tab>'
      end
    end, { expr = true, silent = true })
    
    -- Optional: Auto-enable for markdown files (uncomment if you want)
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "markdown",
    --   callback = function()
    --     vim.cmd("TableModeEnable")
    --   end,
    -- })
  end,
}
