vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", function()
  local buf_ft = vim.bo.filetype
  if buf_ft == "oil" then
    vim.cmd("silent! bwipeout") -- Close the oil buffer
  end
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:startswith("suda://") then
    local fname = bufname:sub(8)
    vim.cmd.Ex(vim.fn.fnamemodify(fname, ":h"))
  else
    vim.cmd("Ex")
  end
end, { desc = "To netrw" })

vim.keymap.set("n", "<C-t>", function()
  local cddir = vim.fn.getcwd()
  if vim.bo.buftype == "terminal" then
     cddir = vim.fn.systemlist("pwd")[1]
  else
    -- Get the current working directory
    cddir = vim.fn.expand('%:p:h')
  end

  vim.cmd("tabnew")
  vim.cmd("silent Ex " .. cddir)
end, { desc = "New tab" })

vim.keymap.set("n", "<leader>ct", function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.cmd("tabnew")
  vim.api.nvim_set_current_buf(current_buf)
end, { desc = "Clone tab" })

vim.keymap.set("n", "<C-S-l>", ":tabm +1<cr>", { desc = "Move tab right" })
vim.keymap.set("n", "<C-S-h>", ":tabm -1<cr>", { desc = "Move tab left" })

vim.keymap.set("n", "<C-w>", ":q<CR>", { desc = "Close (tab)" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertically" })
-- moved to / used with betterescape
--[[ vim.keymap.set("i", 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set("t", 'jj', '<C-\\><C-n>', { noremap = true, silent = true }) ]]
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
    vim.keymap.set("n", "<BS>", "u", { remap = true, buffer = true })
  end,
})
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>o", "o<ESC>", { desc = "Insert newline" })
vim.keymap.set("n", "<leader>O", "O<ESC>", { desc = "Insert newline previous line" })

vim.keymap.set('c', '<C-Down>', '<C-n>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-Up>', '<C-p>', { noremap = true, silent = true })

local function smart_home()
  local col = vim.fn.col('.')
  local first_non_whitespace = vim.fn.match(vim.fn.getline('.'), '\\S') + 1
  if col == first_non_whitespace then
    vim.cmd('normal! 0')
  else
    vim.cmd('normal! ^')
  end
end

vim.keymap.set("n", "<Home>", smart_home, { remap = true })
vim.keymap.set("i", "<Home>", smart_home, { remap = true })

vim.keymap.set("n", "<leader>pu", function()
  vim.cmd('put ' .. vim.v.register)
end, { desc = "paste after in new line" })
vim.keymap.set("n", "<leader>pU", function()
  vim.cmd('put! ' .. vim.v.register)
end, { desc = "paste before in new line" })
