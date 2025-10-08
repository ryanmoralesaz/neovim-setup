return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require("luasnip")
    
    -- JavaScript snippets
    ls.add_snippets("javascript", {
      ls.snippet("c", {
        ls.text_node("console.log("),
        ls.insert_node(1),
        ls.text_node(");"),
      }),
      ls.snippet("cw", {
        ls.text_node("console.warn("),
        ls.insert_node(1),
        ls.text_node(");"),
      }),
      ls.snippet("creq", {
        ls.text_node("ctx.request"),
      }),
      ls.snippet("cres", {
        ls.text_node("ctx.response"),
      }),
    })
    
    -- TypeScript snippets
    ls.add_snippets("typescript", {
      ls.snippet("c", {
        ls.text_node("console.log("),
        ls.insert_node(1),
        ls.text_node(");"),
      }),
      ls.snippet("cw", {
        ls.text_node("console.warn("),
        ls.insert_node(1),
        ls.text_node(");"),
      }),
      ls.snippet("creq", {
        ls.text_node("ctx.request"),
      }),
      ls.snippet("cres", {
        ls.text_node("ctx.response"),
      }),
    })
    
    -- Tab to expand/jump
    vim.keymap.set({"i", "s"}, "<Tab>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        return "<Tab>"
      end
    end, {silent = true})
    
    -- Shift-Tab to jump backwards
    vim.keymap.set({"i", "s"}, "<S-Tab>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, {silent = true})
  end,
}
