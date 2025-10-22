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
        lua = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 5000,
        lsp_fallback = true,
      },
      formatters = {
        prettier = {
          prepend_args = function(self, ctx)
            local args = {
              "--no-color",
              "--use-tabs=false",
              "--tab-width=2",
            }

            if ctx.filetype == "ejs" then
              table.insert(args, "--parser")
              table.insert(args, "html")
            end

            return args
          end,
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
      },
    })
  end,
}
