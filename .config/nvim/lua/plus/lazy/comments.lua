return {
  "numToStr/Comment.nvim",

  config = function()
    local opts = {
      toggler = {
        line = "<leader>//",
        block = "<leader>/*",
      },
      opleader = {
        line = "//",
        block = "/*",
      },
      extra = nil,
      mappings = {
        extra = false,
      }
    }
    require("Comment").setup(opts)

    local ft = require('Comment.ft')
    ft.set("qml", {"//%s", "/*%s*/"})
  end,
}
