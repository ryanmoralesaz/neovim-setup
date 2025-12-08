return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_use_yarn = 0 -- Add this line to prefer npm over yarn
  end,
  ft = { "markdown" },
  config = function()
    vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Markdown Preview" })
    vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "Stop Markdown Preview" })

    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_refresh_slow = 0

    vim.g.mkdp_theme = 'light'  -- Add this line
    -- Windows-compatible path
    vim.g.mkdp_markdown_css = vim.fn.stdpath("config") .. "/markdown-preview.css"
  end,
}
