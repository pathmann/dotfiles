return {
  "folke/persistence.nvim",

  config = function()
    local per = require("persistence")
    per.setup({})
    per.stop()

    vim.keymap.set("n", "<leader>ql", function()
      per.load()
    end, { desc = "Load session" })
    vim.keymap.set("n", "<leader>qL", function()
      per.select()
    end, { desc = "Select session" })
    vim.keymap.set("n", "<leader>qs", function()
      per.save()
    end, { desc = "Store session" })
  end,
}
