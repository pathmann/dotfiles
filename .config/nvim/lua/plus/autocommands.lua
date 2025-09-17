-- Auto create dir when saving a file, in case some intermediate directory does not exist
-- Copyright: https://github.com/Isrothy/dotfile/blob/master/.config/nvim/lua/isrothy/autocmds.lua
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- close some filetypes with <q>
-- Copyright: https://github.com/Isrothy/dotfile/blob/master/.config/nvim/lua/isrothy/autocmds.lua
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "lspinfo",
    "startuptime",
    "tsplayground",
    "checkhealth",
    "git",
    "qf",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function()
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    vim.opt.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    vim.keymap.set({ "n", "v" }, "<leader><CR>", function()
      local qf_items = vim.fn.getqflist()
      local items_to_open = {}

      local mode = vim.fn.mode()
      if mode == 'v' or mode == 'V' then
        local start_idx = vim.fn.line("v")
        local end_idx = vim.fn.line(".")
        if start_idx > end_idx then
          start_idx, end_idx = end_idx, start_idx
        end

        for i = start_idx, end_idx do
          local item = qf_items[i]
          if item then table.insert(items_to_open, item) end
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
      else
        local idx = vim.fn.line('.')
        local item = qf_items[idx]
        if item then table.insert(items_to_open, item) end
      end

      for _, item in ipairs(items_to_open) do
        vim.cmd("tabnew")

        if item.bufnr and vim.api.nvim_buf_is_valid(item.bufnr) then
          vim.api.nvim_set_current_buf(item.bufnr)
        elseif item.filename then
          vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
        else
          vim.notify("Invalid item: no buffer or filename", vim.log.levels.WARN)
          goto continue
        end

        local lnum = item.lnum or 1
        local col = (item.col or 1) - 1
        vim.api.nvim_win_set_cursor(0, { lnum, col })

        ::continue::
      end
    end, { buffer = args.buf, desc = "Open selected quickfix items in new tabs" })
  end,
})
