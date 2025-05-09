local M = {}

M.name = "harper_ls"

M.ensure_installed = "harper_ls"

M.on_server = true

M.opts = {
  filetypes = {"markdown"},
}

M.on_attach = function()

end

return M
