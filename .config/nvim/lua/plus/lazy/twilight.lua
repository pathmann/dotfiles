return {
  "folke/twilight.nvim",

  config = function()
    local opts = {
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
        "function_definition",
      },
      exclude = {
        "text",
      }
    }

    local tw = require("twilight")
    tw.setup(opts)

    tw.enable()
  end
}
