if vim.fn.has('unix') == 1 and vim.fn.getenv('TMUX') ~= nil then
  vim.api.nvim_create_autocmd({ 'VimResume', 'VimEnter' }, {
    callback = function()
      local tmux_pref_off_path = "/home/thomas/bin/tmux_prefix_off.sh"

      if vim.fn.filereadable(tmux_pref_off_path) ~= 0 then
        vim.fn.system(tmux_pref_off_path)
      end
    end,
  })
  vim.api.nvim_create_autocmd({ 'VimSuspend', 'VimLeave' }, {
    callback = function()
      local tmux_pref_on_path = "/home/thomas/bin/tmux_prefix_on.sh"

      if vim.fn.filereadable(tmux_pref_on_path) ~= 0 then
        vim.fn.system(tmux_pref_on_path)
      end
    end,
  })
end
