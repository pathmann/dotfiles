vim.opt.showtabline = 2 -- always show the top tab line
vim.o.tabline = "%!v:lua.MyTabLine()"

function _G.MyTabLine()
  local s = ""
  for i = 1, vim.fn.tabpagenr('$') do
    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local label = Get_custom_label(bufname)

    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    s = s .. label .. " "
  end
  s = s .. "%#TabLineFill#"
  return s
end

function Get_custom_label(bufname)
  if bufname == "" then
    return "[No Name]"
  end

  local cwd = vim.fn.getcwd()
  local full_path = vim.fn.fnamemodify(bufname, ":p")

  if full_path:startswith(cwd) then
    full_path = full_path:sub(cwd:len() + 1, full_path:len())
  end

  local parts = {}
  for part in string.gmatch(full_path, "[^/]+") do
    table.insert(parts, part)
  end

  local ret = ""
  for i = 1, #parts - 2, 1 do
    ret = ret .. parts[i]:sub(1, 1) .. "/"
  end

  local file = parts[#parts]
  local lastdir = parts[#parts - 1]

  if lastdir then
    ret = ret .. lastdir .. "/"
  end

  return ret .. file
end
