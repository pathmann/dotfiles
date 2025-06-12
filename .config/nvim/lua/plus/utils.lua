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

return M
