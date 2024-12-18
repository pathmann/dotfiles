return {
  "echasnovski/mini.nvim",

  version = "*",

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },

  config = function()
    local spec_treesitter = require('mini.ai').gen_spec.treesitter
    local mini = require("mini.ai")
    mini.setup({
      custom_textobjects = {
        F = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
        P = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = spec_treesitter({ a = '@comment.outer', i = '@comment.inner' }),
      }
    })
  end,
}
