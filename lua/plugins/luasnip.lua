return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require("luasnip")

    -- Load snippets from lua/snippets/ directory
    require("luasnip.loaders.from_lua").load({
      paths = vim.fn.stdpath("config") .. "/lua/snippets",
    })

    -- IMPORTANT: Extend filetypes AFTER loading snippets
    ls.filetype_extend("javascriptreact", { "javascript" })
    ls.filetype_extend("typescriptreact", { "javascript", "typescript" })

    -- Force reload to apply filetype extensions
    require("luasnip.loaders.from_lua").load({
      paths = vim.fn.stdpath("config") .. "/lua/snippets",
    })

    -- Tab to expand/jump
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        return "<Tab>"
      end
    end, { silent = true })

    -- Shift-Tab to jump backwards
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })
  end,
}
