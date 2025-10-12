local M = {}

M.name = "gitlab_ci_ls"

-- if ~= nil, installed with mason
M.ensure_installed = true

-- if the server should be loaded in minimal configuration on servers
M.on_server = false

-- opts to pass to vim.lsp.config(M.name) if M.setup is not defined
M.opts = {}

M.on_attach = function(client, bufnr)

end

return M
