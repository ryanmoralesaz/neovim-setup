local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("c", {
    t("console.log("),
    i(1),
    t(");"),
  }),

  s("cw", {
    t("console.warn("),
    i(1),
    t(");"),
  }),

  s("creq", {
    t("ctx.request"),
  }),

  s("cres", {
    t("ctx.response"),
  }),
}
