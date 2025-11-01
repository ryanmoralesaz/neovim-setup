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

    -- Smart comma comma: snippets first, then Emmet
    vim.keymap.set("i", ",,", function()
      local ls = require("luasnip")

      -- Get word before cursor
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local before_cursor = line:sub(1, col)
      local word = before_cursor:match("(%S+)$") or ""

      -- Check if this word matches any snippet trigger
      local snippets = ls.get_snippets(vim.bo.filetype)
      local has_snippet = false

      if snippets then
        for _, snip in ipairs(snippets) do
          if snip.trigger == word then
            has_snippet = true
            break
          end
        end
      end

      -- If we found a matching snippet AND it can expand, do it
      if has_snippet and ls.expandable() then
        ls.expand()
      else
        -- Otherwise, trigger Emmet
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(emmet-expand-abbr)", true, true, true), "m", false)
      end
    end, { silent = true })
  end,
}
