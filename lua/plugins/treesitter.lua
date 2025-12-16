return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local status, configs = pcall(require, "nvim-treesitter.configs")
    if not status then
        return
    end

    configs.setup({
      ensure_installed = { "html", "css", "javascript", "typescript", "tsx", "json", "lua" },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    })

    vim.treesitter.language.register('html', 'ejs')
  end,
}
