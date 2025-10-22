return {
  "mattn/emmet-vim",
  config = function()
    vim.g.user_emmet_leader_key = "<C-y>"
    vim.g.user_emmet_install_global = 0

    -- Enable for specific filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "html", "css", "ejs", "javascriptreact", "typescriptreact" },
      callback = function()
        vim.cmd("EmmetInstall")
      end,
    })

    -- Global mapping for double comma (not buffer-specific)
    vim.keymap.set("i", ",,", "<Plug>(emmet-expand-abbr)", { silent = true })
  end,
}
