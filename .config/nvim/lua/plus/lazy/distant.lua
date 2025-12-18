return {
  "chipsenkbeil/distant.nvim",

  enabled = not require("plus.utils").is_server(),

  branch = 'v0.3',

  opts = {
    network = {
      private = true,
    },
  },

  config = function(_, opts)
    require('distant'):setup(opts)
  end,
}
