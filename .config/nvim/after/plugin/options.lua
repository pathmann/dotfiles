vim.opt.whichwrap = "b,s,<,>,[,],h,l"
-- Set tab size to 4 spaces
vim.opt.tabstop = 2        -- Number of spaces a tab counts for
vim.opt.shiftwidth = 2     -- Number of spaces to use for each level of indentation
vim.opt.expandtab = true   -- Use spaces instead of tabs

-- Optional: If you want to also set up behavior for auto-indentation
vim.opt.smartindent = true -- Enable smart indentation
vim.opt.autoindent = true  -- Copy indent from the current line when starting a new line

vim.opt.number = true         -- Absolute line numbers
vim.opt.relativenumber = true -- Relative line numbers

vim.opt.clipboard = "unnamedplus"

vim.opt.showtabline = 2 -- always show the top tab line
vim.g.netrw_sort_options = "i"
vim.g.netrw_sort_sequence = "[/]$"
