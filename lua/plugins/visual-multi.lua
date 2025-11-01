return {
  "mg979/vim-visual-multi",
  branch = "master",
  -- DISABLED: Use multiple-cursors.nvim instead (vim-visual-multi is janky)
  enabled = false,
  config = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Select All"] = "<Leader>a",
      ["Skip Region"] = "<C-x>",
      ["Remove Region"] = "<C-p>",
      ["Undo"] = "u",
      ["Redo"] = "<C-r>",
    }

    -- Exit with Ctrl+c and clear highlights
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_start",
      callback = function()
        vim.keymap.set("n", "<C-c>", function()
          vim.cmd("VMClear")
          vim.cmd("nohlsearch")
        end, { buffer = true, silent = true })
      end,
    })

    -- Clear highlights when exiting VM mode
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_exit",
      callback = function()
        vim.cmd("nohlsearch")
        vim.schedule(function()
          vim.cmd("nohlsearch")
        end)
      end,
    })
  end,
}
