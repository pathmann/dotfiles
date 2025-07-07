local M = {}

function string:startswith(start)
    return self:sub(1, #start) == start
end

function string:endswith(suffix)
    return self:sub(-#suffix) == suffix
end

M.is_server = function()
  local hostname = vim.fn.hostname()

  if hostname == "roentgen" then
    return true
  end

  if hostname:startswith("gear") then
    return true
  end

  return false
end

M.set_local_folding = function(buf)
  vim.api.nvim_buf_call(buf, function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt_local.foldenable = true
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldlevelstart = 99
    if vim.fn.mode() == "n" then
      vim.cmd("silent! normal! zx")
    end
  end)
end

return M
