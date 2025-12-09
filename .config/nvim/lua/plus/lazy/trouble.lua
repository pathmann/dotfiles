return {
  "folke/trouble.nvim",

  opts = {}, -- for default options, refer to the configuration section for custom setup.

  cmd = "Trouble",

  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Diagnostics current buf",
    },
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix list",
    },
  }
}
