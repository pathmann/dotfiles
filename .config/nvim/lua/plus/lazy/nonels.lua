return {
  "nvimtools/none-ls.nvim",

  config = function() 
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.clazy.with({
          filetypes = { "cpp" }
        }),
        null_ls.builtins.hover.printenv.with({
          filetypes = { "sh", "dosbatch", "ps1", "qmake" }
        }),
      },
    })

    -- dummy to activate it on qmake files (to get cmp)
    local qmake = {
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { "qmake" },
      generator = {
        fn = function()
          return {}
        end,
      },
    }

    null_ls.register(qmake)
  end,
}
