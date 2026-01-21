-- Set leader key FIRST (CRITICAL - must be before any plugin loading)
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- Bootstrap lazy.nvim (MUST come before require("lazy"))
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

-- NOW we can setup lazy (after bootstrap)
require("lazy").setup("plugins")

-- Recognize file extensions
vim.filetype.add({
  extension = {
    ejs = "html",
    jsx = "javascriptreact",
    tsx = "typescriptreact",
  },
})

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

-- Neo tree toggle ctrl+n and ;+n
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>n", ":Neotree toggle<CR>", { silent = true })
vim.opt.timeoutlen = 300

-- Show filename in the title/tabline
vim.opt.title = true
vim.opt.titlestring = "%t - nvim"

-- Set JavaScript-style comments
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    vim.bo.commentstring = "// %s"
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

-- Toggle comment with two periods
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

-- Visual mode: Toggle block comments
vim.keymap.set("v", "..", function()
  local ft = vim.bo.filetype
  local comment_start = "--"
  local comment_end = ""
  local use_block_comment = false

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

  local is_commented = false
  if use_block_comment then
    is_commented = first_line:match("^%s*" .. vim.pesc(comment_start))
  else
    is_commented = first_line:match("^%s*" .. vim.pesc(comment_start))
  end

  if use_block_comment then
    if is_commented then
      local first = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]
      local last = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)[1]
      local pattern_start = "^(%s*)" .. vim.pesc(comment_start) .. "%s?"
      local pattern_end = "%s?" .. vim.pesc(comment_end) .. "(%s*)$"
      first = first:gsub(pattern_start, "%1", 1)
      last = last:gsub(pattern_end, "%1", 1)
      vim.api.nvim_buf_set_lines(0, start_line - 1, start_line, false, { first })
      vim.api.nvim_buf_set_lines(0, end_line - 1, end_line, false, { last })
    else
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

-- Enter always creates new line
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e><CR>", true, false, true), "n", false)
    return ""
  else
    return "<CR>"
  end
end, { expr = true, noremap = true, silent = true })

-- Tab navigates completion menu or jumps in snippets
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
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
    return "<C-p>"
  else
    local ls = require("luasnip")
    if ls.jumpable(-1) then
      return "<Cmd>lua require('luasnip').jump(-1)<CR>"
    else
      return "<S-Tab>"
    end
  end
end, { expr = true, silent = true })

-- Auto-open layout: Neo-tree + Code + Terminal
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      vim.cmd("Neotree show left")

      vim.defer_fn(function()
        vim.cmd("wincmd l")
        -- Changed to horizontal split below (split instead of vsplit)
        -- vim.cmd("botright split | terminal")

        local term_win = vim.api.nvim_get_current_win()
        local screen_width = vim.o.columns
        local screen_height = vim.o.lines
        local neotree_width = math.floor(screen_width / 5)
        -- Terminal takes up 1/3 of screen height
        -- local terminal_height = math.floor(screen_height / 3)

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_buf_get_option(buf, "filetype")
          if ft == "neo-tree" then
            vim.api.nvim_win_set_width(win, neotree_width)
          end
        end

        vim.api.nvim_win_set_height(term_win, terminal_height)
        vim.cmd("wincmd k") -- Move focus back to editor (up instead of left)
      end, 100)
    end
  end,
})
-- Clipboard settings - works for both local and SSH
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

vim.opt.clipboard = "unnamedplus"
vim.opt.foldcolumn = "2"
-- Exit terminal mode with 'hh'
vim.keymap.set("t", "hh", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Terminal and display settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false

-- Choose shell for OS
if vim.fn.has("win32") == 1 then
  vim.o.shell = "/usr/bin/zsh"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
else
  vim.o.shell = vim.fn.executable("zsh") == 1 and "zsh" or "bash"
end

vim.keymap.set("n", "<leader>t", ":botright vsp | terminal<CR>", { desc = "Open terminal in vsplit" })

-- Indentation settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Auto-save settings
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

-- Wrap at word boundaries
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakat = " \t"

-- Auto-reload files when changed externally
vim.opt.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})
