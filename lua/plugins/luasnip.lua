return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require("luasnip")

    -- HTML snippets
    ls.add_snippets("html", {
      ls.snippet("bang", {
        ls.text_node({
          "<!DOCTYPE html>",
          '<html lang="en">',
          "<head>",
          '    <meta charset="UTF-8">',
          '    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
          "    <title>",
        }),
        ls.insert_node(1, "Document"),
        ls.text_node({
          "</title>",
          "</head>",
          "<body>",
          "    ",
        }),
        ls.insert_node(2),
        ls.text_node({
          "",
          "</body>",
          "</html>",
        }),
      }),
    })
    --
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
