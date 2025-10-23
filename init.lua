--- Show filename in the title/tabline
vim.opt.title = true
vim.opt.titlestring = "%t - nvim" -- %t = tail of filename- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Recognize EJS files
vim.filetype.add({
  extension = {
    ejs = "html",
    jsx = "javascriptreact",
    tsx = "typescriptreact",
  },
})

-- Set JavaScript-style comments
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- create clean conformlogs
vim.api.nvim_create_user_command("CleanLog", function()
  vim.cmd("%s/\\[[0-9;]*m//g")
end, {})

-- Disable all auto-commenting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Toggle comment with two periods (handles -- and //)
vim.keymap.set("n", "..", function()
  local line = vim.api.nvim_get_current_line()
  local ft = vim.bo.filetype

  -- Determine comment style based on filetype
  local comment_chars = "--"
  if ft:match("javascript") or ft:match("typescript") or ft:match("java") or ft:match("c") then
    comment_chars = "//"
  end

  local commented = line:match("^%s*" .. vim.pesc(comment_chars))

  if commented then
    -- Uncomment
    local pattern = "^(%s*)" .. vim.pesc(comment_chars) .. "%s?"
    local new_line = line:gsub(pattern, "%1", 1)
    vim.api.nvim_set_current_line(new_line)
  else
    -- Comment
    local indent = line:match("^%s*") or ""
    local content = line:sub(#indent + 1)
    vim.api.nvim_set_current_line(indent .. comment_chars .. " " .. content)
  end
end, { desc = "Toggle comment" })

-- Setup lazy.nvim
require("lazy").setup("plugins")

-- Auto-open layout: Neo-tree (left 1/5) + Code (middle 3/5) + Terminal (right 1/5)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only run if opening a directory or no arguments
    if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      -- Open Neo-tree on the left
      vim.cmd("Neotree show left")

      -- Wait a bit for Neo-tree to open
      vim.defer_fn(function()
        -- Focus the main window
        vim.cmd("wincmd l")

        -- Open terminal on the right in a vertical split
        vim.cmd("rightbelow vsplit | terminal")

        -- Get the terminal window
        local term_win = vim.api.nvim_get_current_win()

        -- Set Neo-tree width (1/5 of screen)
        local screen_width = vim.o.columns
        local neotree_width = math.floor(screen_width / 5)
        local terminal_width = math.floor(screen_width / 5)

        -- Find Neo-tree window and set its width
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_buf_get_option(buf, "filetype")
          if ft == "neo-tree" then
            vim.api.nvim_win_set_width(win, neotree_width)
          end
        end

        -- Set terminal width
        vim.api.nvim_win_set_width(term_win, terminal_width)

        -- Focus back to the middle (code) window
        vim.cmd("wincmd h")
      end, 100)
    end
  end,
})

-- Use OSC 52 for SSH, native clipboard for local
if vim.env.SSH_CONNECTION then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
else
  vim.opt.clipboard = "unnamedplus"
end

-- Tree shortcut
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { silent = true })
vim.opt.foldcolumn = "2"
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Terminal and display settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false
-- choose shell for os
if vim.fn.has('win32') == 1 then
  vim.o.shell = 'pwsh'
else
  vim.o.shell = vim.fn.executable('zsh') == 1 and 'zsh' or 'bash'
end

vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- Open terminal with \+t
vim.keymap.set("n", "<leader>t", ":botright vsp | terminal<CR>", { desc = "Open terminal in vsplit" })

-- Indentation settings (add this near the top with your other vim.opt settings)
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Number of spaces for indentation
vim.opt.tabstop = 2 -- Number of spaces a tab counts for
vim.opt.softtabstop = 2 -- Number of spaces for editing operations

-- Auto-save settings
vim.opt.autowrite = true
vim.opt.autowriteall = true

-- Auto-save WITHOUT formatting on InsertLeave/BufLeave/FocusLost
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave" }, {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      -- Save WITHOUT formatting (noautocmd prevents format_on_save from triggering)
      vim.api.nvim_command("silent! noautocmd write")
    end
  end,
})
