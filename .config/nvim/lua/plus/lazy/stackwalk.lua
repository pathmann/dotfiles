return {
  "pathmann/stackwalk.nvim",

  enabled = not require("plus.utils").is_server(),

  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  -- dev = true,

  opts = {},
}
