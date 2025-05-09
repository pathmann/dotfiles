local M = {}

M.name = "qmlls"

M.on_server = false

M.opts = {
  cmd = {"qmlls6"},
  single_file_support = true,
  filetypes = {"qml"},
  root_dir = vim.fn.getcwd(),
}

M.on_attach = function()

end

return M
