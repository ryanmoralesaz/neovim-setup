return {
  "folke/edgy.nvim",
  lazy = false,  -- Load immediately instead of VeryLazy
  opts = {
    left = {
      {
        title = "Files",
        ft = "NvimTree",
        size = { height = 0.6 },
      },
      {
        title = "Terminal",
        ft = "terminal",
        size = { height = 0.4 },
      },
    },
  }
}
