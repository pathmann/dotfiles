local utils = require("new-file-template.utils")

local function main_source_template()
  return [[


int main(int argc, char** argv) {
  |cursor|
  return 0;
}
]]
end

local function base_template(relative_path, filename)
  if filename == "main.cpp" then
    return main_source_template()
  end

  local header = vim.split(filename, "%.")[1] .. ".h"
  return [[
#include "]] .. header .. [["
|cursor| 
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
