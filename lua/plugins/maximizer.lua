return {
  "szw/vim-maximizer",
  config = function()
    vim.keymap.set("n", "<leader>m", ":MaximizerToggle<CR>", { desc = "Toggle maximize window" })
  end,
}
