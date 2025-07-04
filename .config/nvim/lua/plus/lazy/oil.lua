return {
  "stevearc/oil.nvim",

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local oil = require("oil")
    oil.setup({
      default_file_explorer = false,
      columns = {
        "icons",
      },
      keymaps = {
        ["<C-h>"] = false,
      },
      view_options = {
        show_hidden = true,
      },
    })

    vim.keymap.set("n", "<leader>p-", "<cmd>Oil<CR>", { desc = "Parent dir in oil" })
  end,
}
