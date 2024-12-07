return {
  "mbbill/undotree",

  config = function()
    vim.keymap.set("n", "<leader>uu", function()
      vim.cmd("UndotreeToggle")
      vim.cmd("UndotreeFocus")
    end, { desc = "Undotree toggle" })
  end,

  init = function()
    vim.g.undotree_WindowLayout = 2
  end
}

