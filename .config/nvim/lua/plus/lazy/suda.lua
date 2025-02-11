return {
  "lambdalisue/vim-suda",

  init = function()
    --don't use suda_smart_edit when opening a file in /tmp/pid-<pid>
    --so this won't interfere when opening thunderbird attachments
    local pref = "/tmp/pid-"

    local bufs = vim.api.nvim_list_bufs()
    for _, b in ipairs(bufs) do
      local bname = vim.api.nvim_buf_get_name(b)
      if bname:sub(0, pref:len()) == pref then
        return
      end
    end

    vim.g.suda_smart_edit = 1
  end,
}
