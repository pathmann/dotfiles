local M = {}

M.name = "lua_ls"

M.ensure_installed = "lua_ls"

M.on_server = true

M.opts = {
  settings = {
    Lua = {
      runtime = { version = "Lua 5.1" },
      diagnostics = {
        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
      }
    }
  },
}

M.on_attach = function()

end

return M
