return {
  "danymat/neogen", 

  opts = {
    languages = {
      python = {
        template = {
          annotation_convention = "reST",
        },
      },
    },
  },

  config = function(_, opts)
    require('neogen').setup(opts)

    vim.keymap.set("n", "<leader>cd", "<cmd>Neogen<cr>", { desc = "Create docstring" })
  end,
}
