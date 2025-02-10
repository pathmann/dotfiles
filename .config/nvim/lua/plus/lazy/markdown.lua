return {
  "OXY2DEV/markview.nvim",

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },

  config = function()
    local mv = require("markview")
    mv.setup({
      preview = {
        enable = false,
      }
    })
    vim.keymap.set("n", "<leader>mp", "<cmd>Markview splitToggle<cr>", { desc = "Toggle markdown preview" })
  end,
}
