vim.cmd("filetype indent on")
-- Set leader key FIRST (CRITICAL - must be before any plugin loading)
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
-- escape key to h,h
vim.keymap.set("i", "hh", "<Esc>")
-- Window navigation with ;w
vim.keymap.set("n", "<leader>bh", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<leader>bj", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<leader>bk", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<leader>bl", "<C-w>l", { desc = "Move to right window" })

-- Window splits
vim.keymap.set("n", "<leader>bv", "<C-w>v", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>bs", "<C-w>s", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>bq", "<C-w>q", { desc = "Close window" })
vim.keymap.set("n", "<leader>bo", "<C-w>o", { desc = "Close other windows" })

-- Window resizing with leader key
vim.keymap.set("n", "<leader>=", "<C-w>10>", { desc = "Widen window" })
vim.keymap.set("n", "<leader>-", "<C-w>10<", { desc = "Narrow window" })
vim.keymap.set("n", "<leader>+", "<C-w>10+", { desc = "Taller window" })
vim.keymap.set("n", "<leader>_", "<C-w>10-", { desc = "Shorter window" })

-- Neo tree toggle ctrl+n and ;+n
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>n", ":Neotree toggle<CR>", { silent = true })
vim.opt.timeoutlen = 300 -- Make ;n faster (reduces wait time for leader key)

-- Show filename in the title/tabline
vim.opt.title = true
vim.opt.titlestring = "%t - nvim"

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

-- Recognize file extensions
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

-- JavaScript/TypeScript indentation and shortcuts
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true

    -- Auto-expand curly braces
    vim.keymap.set("i", "{}", "<Esc>A{<CR>}<Esc>O", { buffer = true, desc = "Auto-expand braces" })
  end,
})
-- PHP indentation and shortcuts
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true

    -- Ensure these are set to 2 so the "O" jump knows how far to go
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true

    -- Remove the indentexpr = "" line to let Neovim use its internal PHP rules

    -- PHP shortcuts
    vim.keymap.set("i", ",.", "->", { buffer = true })
    vim.keymap.set("i", "/.", "<?php ", { buffer = true })
    vim.keymap.set("i", "./", "?> ", { buffer = true })

    -- The Magic Expansion
    -- Typing }} will now: Exit insert, place the brace,
    -- and 'O' will open a perfectly indented line above it.
    vim.keymap.set("i", "{}", "<Esc>A{<CR>}<Esc>O", { buffer = true })
  end,
})
-- Create clean conformlogs
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

-- Toggle comment with two periods (handles --, //, /* */, <!-- -->)
vim.keymap.set("n", "..", function()
  local line = vim.api.nvim_get_current_line()
  local ft = vim.bo.filetype

  local comment_start = "--"
  local comment_end = ""

  if ft:match("javascript") or ft:match("typescript") or ft:match("java") or ft == "c" or ft == "cpp" then
    comment_start = "//"
  elseif ft == "css" or ft == "scss" or ft == "less" then
    comment_start = "/*"
    comment_end = " */"
  elseif ft == "html" or ft == "xml" then
    comment_start = "<!--"
    comment_end = " -->"
  end

  local is_commented = false
  if comment_end == "" then
    is_commented = line:match("^%s*" .. vim.pesc(comment_start))
  else
    is_commented = line:match("^%s*" .. vim.pesc(comment_start)) and line:match(vim.pesc(comment_end) .. "%s*$")
  end

  if is_commented then
    local new_line = line
    if comment_end == "" then
      local pattern = "^(%s*)" .. vim.pesc(comment_start) .. "%s?"
      new_line = new_line:gsub(pattern, "%1", 1)
    else
      local pattern_start = "^(%s*)" .. vim.pesc(comment_start) .. "%s?"
      local pattern_end = "%s?" .. vim.pesc(comment_end) .. "(%s*)$"
      new_line = new_line:gsub(pattern_start, "%1", 1)
      new_line = new_line:gsub(pattern_end, "%1", 1)
    end
    vim.api.nvim_set_current_line(new_line)
  else
    local indent = line:match("^%s*") or ""
    local content = line:sub(#indent + 1)
    vim.api.nvim_set_current_line(indent .. comment_start .. " " .. content .. comment_end)
  end
end, { desc = "Toggle comment" })

-- Visual mode: Toggle block comments (adds /* at start, */ at end for JS/CSS)
vim.keymap.set("v", "..", function()
  local ft = vim.bo.filetype
  local comment_start = "--"
  local comment_end = ""
  local use_block_comment = false

  -- Determine comment style
  if ft:match("javascript") or ft:match("typescript") or ft:match("java") or ft == "c" or ft == "cpp" then
    comment_start = "/*"
    comment_end = " */"
    use_block_comment = true
  elseif ft == "css" or ft == "scss" or ft == "less" then
    comment_start = "/*"
    comment_end = " */"
    use_block_comment = true
  elseif ft == "html" or ft == "xml" then
    comment_start = "<!--"
    comment_end = " -->"
    use_block_comment = true
  else
    -- Line comment style for other filetypes
    if ft:match("python") then
      comment_start = "#"
    elseif ft == "lua" then
      comment_start = "--"
    else
      comment_start = "//"
    end
  end

  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local first_line = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]

  -- Check if first line is commented
  local is_commented = false
  if use_block_comment then
    is_commented = first_line:match("^%s*" .. vim.pesc(comment_start))
  else
    is_commented = first_line:match("^%s*" .. vim.pesc(comment_start))
  end

  if use_block_comment then
    -- Block comment: only modify first and last lines
    if is_commented then
      -- Uncomment: remove /* from first line and */ from last line
      local first = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]
      local last = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)[1]

      local pattern_start = "^(%s*)" .. vim.pesc(comment_start) .. "%s?"
      local pattern_end = "%s?" .. vim.pesc(comment_end) .. "(%s*)$"

      first = first:gsub(pattern_start, "%1", 1)
      last = last:gsub(pattern_end, "%1", 1)

      vim.api.nvim_buf_set_lines(0, start_line - 1, start_line, false, { first })
      vim.api.nvim_buf_set_lines(0, end_line - 1, end_line, false, { last })
    else
      -- Comment: add /* to first line and */ to last line
      local first = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]
      local last = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)[1]

      local indent_first = first:match("^%s*") or ""
      local content_first = first:sub(#indent_first + 1)

      first = indent_first .. comment_start .. " " .. content_first
      last = last .. comment_end

      vim.api.nvim_buf_set_lines(0, start_line - 1, start_line, false, { first })
      vim.api.nvim_buf_set_lines(0, end_line - 1, end_line, false, { last })
    end
  else
    -- Line comment: comment each line individually
    for line_num = start_line, end_line do
      local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
      local new_line

      if is_commented then
        local pattern = "^(%s*)" .. vim.pesc(comment_start) .. "%s?"
        new_line = line:gsub(pattern, "%1", 1)
      else
        local indent = line:match("^%s*") or ""
        local content = line:sub(#indent + 1)
        new_line = indent .. comment_start .. " " .. content
      end

      vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { new_line })
    end
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Toggle block comment on selection" })

-- Completion settings
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Enter always creates new line (doesn't accept completion)
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    -- Close the completion menu and insert a newline
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e><CR>", true, false, true), "n", false)
    return ""
  else
    return "<CR>"
  end
end, { expr = true, noremap = true, silent = true })

-- Tab navigates completion menu or jumps in snippets
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>" -- Next completion item
  else
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then
      return "<Cmd>lua require('luasnip').expand_or_jump()<CR>"
    else
      return "<Tab>"
    end
  end
end, { expr = true, silent = true })

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>" -- Previous completion item
  else
    local ls = require("luasnip")
    if ls.jumpable(-1) then
      return "<Cmd>lua require('luasnip').jump(-1)<CR>"
    else
      return "<S-Tab>"
    end
  end
end, { expr = true, silent = true })

-- Setup lazy.nvim
require("lazy").setup("plugins")

-- Auto-open layout: Neo-tree + Code + Terminal
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      vim.defer_fn(function()
        require("neo-tree")
        vim.cmd("Neotree show left")

        vim.defer_fn(function()
          --        vim.cmd("wincmd l")
          --      vim.cmd("rightbelow vsplit | terminal")

          local term_win = vim.api.nvim_get_current_win()
          local screen_width = vim.o.columns
          local neotree_width = math.floor(screen_width / 5)
          --    local terminal_width = math.floor(screen_width / 5)

          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            if ft == "neo-tree" then
              vim.api.nvim_win_set_width(win, neotree_width)
            end
          end

          --        vim.api.nvim_win_set_width(term_win, terminal_width)
          vim.cmd("wincmd h")
        end, 50)
      end, 100)
    end
  end,
})

-- Use OSC 52 for SSH, native clipboard for local
if vim.env.SSH_CONNECTION then
  vim.g.clipboard = {
    name = "osc52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

vim.opt.clipboard = "unnamedplus"
vim.opt.foldcolumn = "2"

-- Exit terminal mode with 'hh' (more reliable than Esc, especially in PowerShell)
vim.keymap.set("t", "hh", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", ",.", "->", { desc = "Arrow operator in terminal" })

-- Terminal and display settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false

-- Choose shell for OS (cross-platform)
if vim.fn.has("win32") == 1 then
  vim.o.shell = "pwsh"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
else
  vim.o.shell = vim.fn.executable("zsh") == 1 and "zsh" or "bash"
end

vim.keymap.set("n", "<leader>t", ":botright vsp | terminal<CR>", { desc = "Open terminal in vsplit" })
vim.keymap.set("n", "<leader>h", ":sp | terminal<CR>", { desc = "Open terminal in hsplit" })
-- Toggle terminal (opens if closed, hides if open)
vim.keymap.set("n", "<leader>tt", function()
  local term_wins = vim.tbl_filter(function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    return vim.bo[buf].buftype == "terminal"
  end, vim.api.nvim_list_wins())

  if #term_wins > 0 then
    -- Close all terminal windows
    for _, win in ipairs(term_wins) do
      vim.api.nvim_win_close(win, false)
    end
  else
    -- Open terminal (or reopen last one)
    vim.cmd("rightbelow vsp | terminal")
  end
end, { desc = "Toggle terminal" })

-- Indentation settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Auto-save settings (robust version with multiple triggers)
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.updatetime = 200

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave", "TextChanged", "CursorHold", "CursorHoldI" }, {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].modified and not vim.bo[buf].readonly and vim.fn.expand("%") ~= "" and vim.bo[buf].buftype == "" then
      vim.cmd("silent! noautocmd write")
    end
  end,
})

-- Clear search highlights with Ctrl+h
vim.keymap.set("n", "<C-h>", ":nohlsearch<CR>", { silent = true })
-- MAC CRITICAL SETTINGS
-- no swap on paste
vim.keymap.set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })
-- wrap at word boundaries
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakat = " \t"
-- auto-reload files when changed externally
vim.opt.autoread = true

-- Create autocommand for checking file changes
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})
