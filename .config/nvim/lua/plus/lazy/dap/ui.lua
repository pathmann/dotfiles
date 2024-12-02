local dapui = require("dapui")

dapui.setup({
  layouts = {
    {
      elements = {
        { id = "stacks", size = 0.50 },
        { id = "breakpoints", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 56,
      position = "right",
    },
    {
      elements = {
        { id = "repl", size = 0.60 },
        { id = "console", size = 0.40 },
      },
      size = 8,
      position = "bottom",
    },
  },
  controls = {
    icons = {
      pause = '',
      play = ' (C-R)',
      step_into = ' (F6)',
      step_over = ' (F7)',
      step_out = ' (F8)',
      step_back = ' (F9)',
      run_last = ' (F10)',
      terminate = ' (F12)',
      disconnect = ' ([l]d)',
    }
  }
})

local dap = require("dap")
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end

vim.keymap.set("n", "<leader>td", function()
  dapui.toggle({})
end, { desc = "Toggle DAP UI" })
--[[
--dap.listeners.before.event_terminated['dapui_config'] = function(e)
  require('utils').info(
    string.format(
      "program '%s' was terminated.",
      vim.fn.fnamemodify(e.config.program, ':t')
    )
  )
  dapui.close()
end
]]
