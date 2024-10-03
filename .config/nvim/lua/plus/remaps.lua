vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-t>", function()
  local cddir = vim.fn.getcwd()
  if vim.bo.buftype == "terminal" then
     cddir = vim.fn.systemlist("pwd")[1]
  else
    -- Get the current working directory
    cddir = vim.fn.expand('%:p:h')
  end

  vim.cmd("tabnew")
  vim.cmd("cd " .. cddir)
  vim.cmd("Ex")
end)

vim.keymap.set("n", "<C-w>", ":q<CR>")
vim.keymap.set("n", "<leader>sh", ":split<CR>")
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>")
vim.keymap.set("i", 'jj', '<Esc>', { noremap = true, silent = true })
-- leave terminal mode
vim.keymap.set("t", 'jj', '<C-\\><C-n>', { noremap = true, silent = true })
vim.keymap.set("t", '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

local function go_left_or_tab()
    local current_window = vim.api.nvim_get_current_win()
    local left_window = vim.fn.win_getid(vim.fn.winnr('h'))

    if left_window ~= 0 and current_window ~= left_window then
        vim.cmd('wincmd h')  -- Move to the left split
    else
        vim.cmd('tabprevious') -- Move to the previous tab
    end
end

-- Function to navigate to the right split or next tab
local function go_right_or_tab()
    local current_window = vim.api.nvim_get_current_win()
    local right_window = vim.fn.win_getid(vim.fn.winnr('l'))

    if right_window ~= 0 and current_window ~= right_window then
        vim.cmd('wincmd l')  -- Move to the right split
    else
        vim.cmd('tabnext')    -- Move to the next tab
    end
end

vim.keymap.set("n", '<C-h>', go_left_or_tab)
vim.keymap.set("n", '<C-l>', go_right_or_tab)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", '<C-l>', go_right_or_tab, { remap = true, buffer = true })
  end,
})
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n","<Tab", ">>")
vim.keymap.set("n", "<S-Tab>", "<<")
vim.keymap.set("i", "<S-Tab>", "<C-\\><C-N><<<C-\\><C-N>^i")

vim.keymap.set("n", "<C-r>", function() 
  OpenNamedTermAndRun()
end
)
