local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local devpath = "~/Projects"
if vim.fn.hostname() == "heisenberg" then
  devpath = "/media/PROJECTS/Active/neovim"
end

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "plus.lazy",
    change_detection = { notify = false },
    dev = {
      path = devpath,
      fallback = false,
    }
})
