return {
  "folke/snacks.nvim",

  priority = 1000,

  lazy = false,

  opts = {
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    debug = { enabled = true },
  },

  keys = {
    { "<leader>sn", function()
      Snacks.notifier.show_history()
    end, desc = "Show notification history" },
  }
}
