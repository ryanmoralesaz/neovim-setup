local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

return {
  s("react", {
    t("import React from 'react';"),
    t({ "", "" }),
    t("const "),
    i(1, "ComponentName"),
    t(" = () => {"),
    t({ "", "  return (" }),
    t({ "", "    <div>" }),
    t({ "", "      " }),
    i(2, "content"),
    t({ "", "    </div>" }),
    t({ "", "  );" }),
    t({ "", "};" }),
    t({ "", "" }),
    t("export default "),
    rep(1),
    t(";"),
  }),

  s("usestate", {
    t("const ["),
    i(1, "state"),
    t(", set"),
    i(2, "State"),
    t("] = useState("),
    i(3),
    t(");"),
  }),

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

  -- NEW: Error handler snippet
  s("iferr", {
    t("if (err) return console.error(err.message);"),
  }),
}
