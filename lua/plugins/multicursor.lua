-- plugins/multicursor.lua
return {
  "mg979/vim-visual-multi",
  config = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-d>", -- Ctrl+d to select next occurrence
      ["Find Subword Under"] = "<C-d>",
      ["Skip Region"] = "<C-x>", -- Ctrl+x to skip current and go to next
      ["Remove Region"] = "<C-p>", -- Ctrl+p to remove current cursor
    }
  end,
}
