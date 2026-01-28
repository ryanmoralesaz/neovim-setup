return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
      javascriptreact = { "eslint" },
      typescriptreact = { "eslint" },
      html = { "htmlhint" },
      css = { "stylelint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
      callback = function()
        local lint = require("lint")
        local linters = lint.linters_by_ft[vim.bo.filetype]

        if linters then
          -- Check if at least one linter binary exists
          local has_linter = false
          for _, linter_name in ipairs(linters) do
            if vim.fn.executable(linter_name) == 1 then
              has_linter = true
              break
            end
          end

          -- Only try to lint if the binary exists
          if has_linter then
            pcall(function()
              lint.try_lint()
            end)
          end
        end
      end,
    })
  end,
}
