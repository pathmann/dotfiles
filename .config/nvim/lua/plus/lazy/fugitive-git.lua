return {
  "tpope/vim-fugitive",

  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "git",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        -- Prevent opening multiple tabs for same buffer
        if vim.fn.tabpagenr('$') == 1 or vim.fn.winnr('$') > 1 then
          -- Open new tab
          vim.cmd("tabnew")
          -- Load the buffer in the new tab
          vim.api.nvim_set_current_buf(buf)
          -- Close the original window if it's still showing the buffer
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == buf and win ~= vim.api.nvim_get_current_win() then
              vim.api.nvim_win_close(win, true)
            end
          end
        end
      end,
    })
  end,
}
