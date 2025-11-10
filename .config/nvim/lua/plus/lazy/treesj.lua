return {
  "Wansmer/treesj",

  event = "VeryLazy",

  opts = {
    use_default_keymaps = false,
    max_join_length = 1000,
    langs = {},
  },

  config = function(_, opts)
    if opts.langs.qmls == nil then
      opts.langs.qmljs = require('treesj.langs.javascript')
    end

    require("treesj").setup(opts)

    vim.keymap.set('n', '<leader>at', require('treesj').toggle, { desc = "Array toggle join/split" })
    vim.keymap.set('n', '<leader>aj', require("treesj").join, { desc = "Array join"})
    vim.keymap.set('n', '<leader>as', require("treesj").split, { desc = "Array split" })
  end,
}
