return {
  "mistweaverco/kulala.nvim",
  config = function()
    require("kulala").setup({
      -- Default settings (uses jq for formatting)
    })

    -- Keybindings
    vim.keymap.set("n", "<leader>r", ':lua require("kulala").run()<CR>', { desc = "Run HTTP request" })
    vim.keymap.set("n", "<leader>R", ':lua require("kulala").run_all()<CR>', { desc = "Run all requests" })
    vim.keymap.set("n", "<leader>p", ':lua require("kulala").jump_prev()<CR>', { desc = "Jump to previous request" })
    vim.keymap.set("n", "<leader>n", ':lua require("kulala").jump_next()<CR>', { desc = "Jump to next request" })
  end,
}
