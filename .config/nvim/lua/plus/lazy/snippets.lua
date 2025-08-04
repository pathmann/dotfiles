return {
  "L3MON4D3/LuaSnip",

  version = "v2.*",

  build = "make install_jsregexp",

  opts = {
    enable_autosnippets = true,
  },

  config = function(_, opts)
    local snip = require("luasnip")
    snip.setup(opts)

    local snippets_path = vim.fn.stdpath("config") .. "/lua/plus/snippets"
    require("luasnip.loaders.from_lua").load({ paths = { snippets_path } })

    local projpath = vim.fn.getcwd() .. "/.nvim-snippets"
    if vim.fn.isdirectory(projpath) ~= 0 then
      require("luasnip.loaders.from_lua").load({ paths = { projpath } })
    end

    vim.keymap.set({"i"}, "<C-K>", function()
      snip.expand()
    end, {silent = true})
  end,
}
