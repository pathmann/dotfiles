Utils = require("plus.utils")

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

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 5

vim.g.netrw_sort_options = "i"
vim.g.netrw_sort_sequence = "[/]$"
vim.g.netrw_bufsettings = 'noma nomod nu nornu nobl nowrap ro'

vim.opt.showtabline = 2 -- always show the top tab line

vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

if os.getenv("SSH_CONNECTION") ~= nil then
  vim.g.clipboard = 'osc52'
end

--don't know why, but necessary to be able to use folding without manually setting foldmethod=expr again
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(args)
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        Utils.set_local_folding(args.buf)
      end
    end, 100) -- wait 100ms to allow Tree-sitter to attach
  end,
})
