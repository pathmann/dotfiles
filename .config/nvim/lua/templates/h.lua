local utils = require("new-file-template.utils")

local function base_template(relative_path, filename)
  local classname = vim.split(filename, "%.")[1]
  local incguardvar = classname:upper() .. "_H__"
  return [[
#ifndef ]] .. incguardvar .. [[

#define ]] .. incguardvar .. [[


class ]] .. classname .. [[ {
|cursor|
};

#endif // ]] .. incguardvar .. [[

]]
end

--- @param opts table
---   A table containing the following fields:
---   - `full_path` (string): The full path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `relative_path` (string): The relative path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `filename` (string): The filename of the new file, e.g., "init.lua".
return function(opts)
  local template = {
    { pattern = ".*", content = base_template },
  }

	return utils.find_entry(template, opts)
end
