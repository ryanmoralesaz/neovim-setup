return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Install parsers for these languages
      ensure_installed = {
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
      },
      
      -- Auto-install missing parsers
      auto_install = true,
      
      -- Enable syntax highlighting
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      
      -- Enable indentation
      indent = {
        enable = true,
      },
    })
    
    -- Treat EJS as HTML for syntax highlighting
    vim.treesitter.language.register('html', 'ejs')
  end,
}
