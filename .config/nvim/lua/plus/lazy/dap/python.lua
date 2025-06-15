local venvdir = os.getenv("WORKON_HOME") or "~/.virtualenvs"
local cwdbase = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

local pypath = venvdir .. "/" .. cwdbase .. "/bin/python"

if vim.fn.filereadable(pypath) == 0 then
  pypath = "python3"
end

require("dap-python").setup(pypath)

