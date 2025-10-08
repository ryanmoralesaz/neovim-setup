return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        width = 30,
      },
      filesystem = {
        filtered_items = {
          visible = true,        -- Show hidden files
          hide_dotfiles = false, -- Don't hide dotfiles
          hide_gitignored = false, -- Show gitignored files
        },
      },
      default_component_configs = {
        container = {
          enable_character_fade = true
        },
        name = {
          use_git_status_colors = true,
        },
      },
      -- Shorter root folder display
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.relativenumber = true
            vim.opt_local.number = true
          end,
        },
      },
    })
    
    vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { silent = true })
  end,
}
