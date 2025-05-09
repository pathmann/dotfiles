local M = {}

M.server_modules = function()
  local ret = {}
  local server_dir = vim.fn.stdpath("config") .. "/lua/plus/lazy/lsp/servers"
  for _, file in ipairs(vim.fn.readdir(server_dir)) do
    if file:sub(-4) == ".lua" and not file:startswith("servertemplate") then
      local module_name = "plus.lazy.lsp.servers." .. file:sub(1, -5)
      table.insert(ret, module_name)
    end
  end

  return ret
end

return M
