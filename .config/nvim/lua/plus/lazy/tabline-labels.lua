return {
  "pathmann/tabline-labels.nvim",

  config = function(_, opts)
    require("tabline-labels").setup(opts)
  end,
}
