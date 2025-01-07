return {
  "folke/persistence.nvim",

  config = function()
    local per = require("persistence")
    per.setup({})
    per.stop()

    vim.keymap.set("n", "<leader>ql", function()
      per.load()
    end, { desc = "Select/Load session" })
    vim.keymap.set("n", "<leader>qs", function()
      per.save()
    end, { desc = "Store session" })
  end,
}
