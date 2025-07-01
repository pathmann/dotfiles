
-- Compute the length of the longest common substring between two strings
local function longest_common_substring(a, b)
  local m, n = #a, #b
  local lcs_matrix = {}
  local max_len = 0

  for i = 1, m do
    lcs_matrix[i] = {}
    for j = 1, n do
      if a:sub(i, i) == b:sub(j, j) then
        if i == 1 or j == 1 then
          lcs_matrix[i][j] = 1
        else
          lcs_matrix[i][j] = lcs_matrix[i - 1][j - 1] + 1
        end
        if lcs_matrix[i][j] > max_len then
          max_len = lcs_matrix[i][j]
        end
      else
        lcs_matrix[i][j] = 0
      end
    end
  end

  return max_len
end

local function find_best_match(cwdbase, venvdir)
  local best_match = nil
  -- minimum most common substring
  local best_score = 3

  for _, name in ipairs(vim.fn.readdir(venvdir)) do
    local python_path = venvdir .. "/" .. name .. "/bin/python"
    if vim.fn.filereadable(python_path) == 1 then
      local score = longest_common_substring(cwdbase, name)
      if score > best_score then
        best_score = score
        best_match = python_path
      end
    end
  end

  return best_match
end

local venvdir = os.getenv("WORKON_HOME") or vim.fn.expand("~/.virtualenvs")
local cwdbase = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

local pypath = find_best_match(cwdbase, venvdir) or "python3"
require("dap-python").setup(pypath)

