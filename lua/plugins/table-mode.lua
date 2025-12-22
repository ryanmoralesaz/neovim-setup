return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "text" },
  config = function()
    -- Use | for corners (standard markdown)
    vim.g.table_mode_corner = '|'
    
    -- Keybindings
    vim.keymap.set('n', '<leader>tm', ':TableModeToggle<CR>', { desc = "Toggle Table Mode" })
    vim.keymap.set('n', '<leader>tr', ':TableModeRealign<CR>', { desc = "Realign Table" })
    
    -- Use Ctrl+] and Ctrl+[ for cell navigation instead of Tab
    vim.keymap.set('i', '<C-]>', function()
      local line = vim.api.nvim_get_current_line()
      if line:match('|') then
        vim.fn.search('|', 'W')
        return '<Right>'
      else
        return ''
      end
    end, { expr = true, silent = true })
    
    vim.keymap.set('i', '<C-[>', function()
      local line = vim.api.nvim_get_current_line()
      if line:match('|') then
        vim.fn.search('|', 'bW')
        return '<Right>'
      else
        return ''
      end
    end, { expr = true, silent = true })
  end,
}
