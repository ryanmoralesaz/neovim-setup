return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Markdown Preview" })
    vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "Stop Markdown Preview" })

    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_markdown_css = vim.fn.stdpath("config") .. "/markdown-preview.css"

    if vim.env.SSH_CONNECTION then
      vim.g.mkdp_open_to_the_world = 1
      vim.g.mkdp_port = 8050
      vim.g.mkdp_echo_preview_url = 1

      -- Convert server IP to localhost for SSH tunnel
      vim.cmd([[
        function! g:OpenMarkdownPreview(url)
          let local_url = substitute(a:url, 'http://[0-9.]\+:', 'http://localhost:', '')
          echom "Preview at: " . local_url
          echom "(Original: " . a:url . ")"
        endfunction
      ]])
      vim.g.mkdp_browserfunc = "g:OpenMarkdownPreview"
    end
  end,
}
