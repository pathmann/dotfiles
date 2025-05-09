local M = {}

M.name = ""

-- if ~= nil, installed with mason
M.ensure_installed = ""

-- if the server should be loaded in minimal configuration on servers
M.on_server = false

-- optional, if not defined, vim.lsp.config(M.name, M.opts) is called 
M.setup = function()

end

-- opts to pass to vim.lsp.config(M.name) if M.setup is not defined
M.opts = {}

-- optional
M.on_attach = function(client, bufnr)

end

return M
