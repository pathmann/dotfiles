local dap = require("dap")

dap.adapters.gdb = {
  id = "gdb",
  type = "executable",
  command = "gdb",
  args = {
    "--quiet",
    "--interpreter=dap"
  },

}

--[[dap.configurations.cpp = {
  {
    name = "Run executable (GDB)",
    type = "gdb",
    request = "launch",
    program = "/home/thomas/Projects/nvimsubdirtest/build/Desktop-Debug/src/app1/app1",
    --[[environment = {
      {
        name = "LD_LIBRARY_PATH",
        value = ""
      }

    }
  },
}
]]
