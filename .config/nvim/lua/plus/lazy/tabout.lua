return {
  "abecodes/tabout.nvim",

  event = "InsertCharPre",

  opts = {},

  priority = 1000,

  depenencies = {
    "nvim-reesitter/nvim-treesitter",
    "L3MON4D3/LuaSnip",
    "hrsh7th/nvim-cmp",
  },
}
