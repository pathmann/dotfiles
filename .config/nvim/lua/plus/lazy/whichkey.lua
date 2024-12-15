return {
  "folke/which-key.nvim",

  event = "VeryLazy",

  config = function()
    require("which-key").setup({})

    require("which-key.plugins.registers").registers = '*+0123456789"-:.%/#=_abcdefghijklmnopqrstuvwxyz'
  end,

  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({
          global = false,
        })
      end,
      desc = "Buffer Keymaps",
    },
  },
}
