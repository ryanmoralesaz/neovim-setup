return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        ejs = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 5000,
        lsp_fallback = true,
      },
      formatters = {
        prettier = {
          prepend_args = function(self, ctx)
            -- Force HTML parser for EJS files
            if ctx.filetype == "ejs" then
              return { "--parser", "html" }
            end
            return {}
          end,
        },
      },
    })
  end,
}
