return {
  "gbprod/yanky.nvim",

  config = function()
    local opts = {

    }

    local y = require("yanky")
    y.setup(opts)

    vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
    vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
    vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
    vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

    vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
    vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

    vim.keymap.set("n", "<leader>pp", function()
      require("telescope").extensions.yank_history.yank_history()
    end, { desc = "Find in history" })
  end
}
