return {
  "jubnzv/IEC.vim",

  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "iec",
      callback = function()
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.expandtab = false
      end,
    })
  end,
}
