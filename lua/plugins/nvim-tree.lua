return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.defer_fn(function()
      require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "rounded",
        window = {
          width = 35,
          position = "left",
          mappings = {
            -- Copy absolute path to clipboard
            ["Y"] = function(state)
              -- Add safety check for state.tree
              if not state.tree then
                print("Neo-tree not fully initialized")
                return
              end
              local node = state.tree:get_node()
              if not node then
                print("No node selected")
                return
              end
              local path = node.path
              vim.fn.setreg("+", path)
              print("Copied absolute: " .. path)
            end,
            -- Copy relative path to clipboard
            ["y"] = function(state)
              -- Add safety check for state.tree
              if not state.tree then
                print("Neo-tree not fully initialized")
                return
              end
              local node = state.tree:get_node()
              if not node then
                print("No node selected")
                return
              end
              local path = node.path
              local cwd = vim.fn.getcwd()
              local rel_path = path:gsub("^" .. vim.pesc(cwd) .. "[/\\]", "")
              vim.fn.setreg("+", rel_path)
              print("Copied relative: " .. rel_path)
            end,
          },
        },
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = false, -- Add this to prevent race conditions
          },
          use_libuv_file_watcher = false, -- Add this - file watcher can cause issues on SSH
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
              vim.opt_local.relativenumber = false
              vim.opt_local.number = false
              vim.opt_local.signcolumn = "no"
              vim.opt_local.foldcolumn = "0"
            end,
          },
        },
      })
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
    end, 50) -- Also changed from 0 to 50ms to give more init time
  end,
}
