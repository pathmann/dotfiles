local function reload_plugin_by_name(plugname)
  require("lazy.core.loader").reload(plugname)
end

local function reload_current_plugin()
  local current_file = vim.fn.expand('%:p')
  local lazy_path = vim.fn.stdpath('data') .. '/lazy/'
  local dev_path = require("lazy.core.config").options.dev.path
  if type(dev_path) == "string" then
    dev_path = vim.fn.expand(dev_path)

    if dev_path[-1] ~= '/' then
      dev_path = dev_path .. "/"
    end
  else
    dev_path = ""
  end

  local plugin_name = nil
  if current_file:find(lazy_path, 1, true) then
    plugin_name = current_file:sub(#lazy_path + 1):match('^[^/]+')
  elseif dev_path ~= "" and current_file:find(dev_path, 1, true) then
    plugin_name = current_file:sub(#dev_path + 1):match('^[^/]+')
  end

  if plugin_name ~= nil then
    reload_plugin_by_name(plugin_name)
  end
end

local function reload_plugin(opts)
  local plugname = nil
  if not vim.tbl_isempty(opts.fargs) then
    plugname = opts.fargs[1]
  end

  if plugname == nil then
    reload_current_plugin()
  else
    reload_plugin_by_name(plugname)
  end
end

vim.api.nvim_create_user_command("ReloadPlugin", reload_plugin, { nargs = "?" })

vim.keymap.set("n", "<leader>rp", ":ReloadPlugin ", { desc = "Reload plugin" })
vim.keymap.set("n", "<leader>rr", reload_current_plugin, { desc = "Reload current plugin"} )
