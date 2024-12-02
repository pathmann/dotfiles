return {
  "pathmann/nvim-dap-project-configuration",

  -- dev = true,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },

  config = function()
    local plug = require("dap-project-configuration")
    plug.setup({})

    vim.keymap.set("n", "<C-r>", "<cmd>ProjectDapRun<CR>", { desc = "Run/Continue DAP" })
    vim.keymap.set("n", "<leader>sr", "<cmd>ProjectDapSelect<CR>", { desc = "Select DAP config" })
    vim.keymap.set("n", "<leader>tr", "<cmd>ProjectDapToggleDap<CR>", { desc = "Toggle Run Dap" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "netrw",
      callback = function()
        vim.keymap.set("n", '<C-r>', "<cmd>ProjectDapRun<CR>", { desc = "Run/Continue DAP", remap = true, buffer = true })
      end,
    })
  end,
}

