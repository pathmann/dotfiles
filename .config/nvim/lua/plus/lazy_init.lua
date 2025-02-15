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

local lazyloader = require("lazy.core.loader")
local config_original = lazyloader.config

---@param plugin LazyPlugin
lazyloader.config = function(plugin)
  local path = vim.fn.getcwd() .. "/." .. plugin.name .. "_options.lua"
  if vim.fn.filereadable(path) == 1 then
    local locopts = loadfile(path)
    if type(locopts) == "function" then
      local cwdopts = locopts()
      if type(cwdopts) ~= "table" then
        vim.notify("local plugin opts for " .. plugin.name .. " did not return a table")
      else
        --I hope this not interfere with lazy's plugin cache
        plugin.opts = vim.tbl_deep_extend("force", plugin.opts or {}, cwdopts)
      end
    end
  end

  config_original(plugin)
end

require("lazy").setup({
    spec = "plus.lazy",
    change_detection = { notify = false },
    dev = {
      path = devpath,
      fallback = false,
    }
})

