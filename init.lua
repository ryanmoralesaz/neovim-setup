-- Bootstrap lazy.nvim
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
vim.api.nvim_create_user_command('CleanLog', function()
  vim.cmd('%s/\\[[0-9;]*m//g')
end, {})

-- Disable all auto-commenting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Toggle comment with two periods (handles -- and //)
vim.keymap.set('n', '..', function()
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

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Tree shortcut
vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { silent = true})
vim.opt.foldcolumn = "2"
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = "Exit terminal mode" })

-- Terminal and display settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.shell = 'pwsh'
vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
vim.opt.shellquote = ''
vim.opt.shellxquote = ''

-- Open terminal with \+t
vim.keymap.set('n', '<leader>t', ':botright vsp | terminal<CR>', { desc = 'Open terminal in vsplit' })
