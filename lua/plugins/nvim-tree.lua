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
      close_if_last_window = false, -- Don't close if it's the last window
      popup_border_style = "rounded",
      window = {
        width = 30, -- Default width, will be overridden by the autocmd
        position = "left",
      },
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        icon = {
          folder_closed = ">",
          folder_open = "v",
          folder_empty = ">",
          default = "",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "[+]",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added = "+",
            modified = "~",
            deleted = "-",
            renamed = "»",
            untracked = "?",
            ignored = "◌",
            unstaged = "x",
            staged = "✓",
            conflict = "!",
          },
        },
      },
      renderers = {
        file = {
          { "icon", enabled = false },
          { "name", use_git_status_colors = true },
          { "git_status", highlight = "NeoTreeDimText" },
        },
        directory = {
          { "icon" },
          { "current_filter" },
          { "name", use_git_status_colors = true },
        },
      },
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

    -- Set git status colors (VS Code style)
    vim.cmd([[
      highlight NeoTreeGitAdded guifg=#98c379
      highlight NeoTreeGitModified guifg=#e5c07b
      highlight NeoTreeGitDeleted guifg=#e06c75
      highlight NeoTreeGitUntracked guifg=#98c379
      highlight NeoTreeGitIgnored guifg=#5c6370
      highlight NeoTreeGitConflict guifg=#e06c75
      highlight NeoTreeGitUnstaged guifg=#e5c07b
      highlight NeoTreeGitStaged guifg=#98c379
    ]])

    vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { silent = true })
  end,
}
