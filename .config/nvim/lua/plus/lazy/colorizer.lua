return {
  "norcalli/nvim-colorizer.lua",

  opts = {
    "*",
  },

  config = function(_, opts)
    vim.opt.termguicolors = true
    require("colorizer").setup(opts)
  end,
}
