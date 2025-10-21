return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    })
    
    -- Treat EJS as HTML
    vim.treesitter.language.register('html', 'ejs')
  end,
}
