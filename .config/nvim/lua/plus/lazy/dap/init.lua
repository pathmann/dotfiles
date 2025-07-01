return {
    "mfussenegger/nvim-dap",

    enabled = not require("plus.utils").is_server(),

    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jbyuki/one-small-step-for-vimkind",
      "nvim-telescope/telescope.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "mfussenegger/nvim-dap-python",
    },

    config = function()
      require('nvim-dap-virtual-text').setup({
        virt_text_pos = "eol",
      })

      vim.keymap.set("n", "<leader>tb", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })

      -- TODO: find better keymaps
      -- don't forget to add them to dap.ui
      vim.keymap.set('n', '<F5>', require 'dap'.continue)
      vim.keymap.set('n', '<F10>', require 'dap'.step_over)
      vim.keymap.set('n', '<F11>', require 'dap'.step_into)
      vim.keymap.set('n', '<F12>', require 'dap'.step_out)

      require("plus.lazy.dap.colors")
      require("plus.lazy.dap.ui")
      require("plus.lazy.dap.cpp")
      require("plus.lazy.dap.rust")
      require("plus.lazy.dap.python")

      require('dap').set_log_level('TRACE')
    end,
}
