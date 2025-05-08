return {
  "pathmann/nvim-dap-project-configuration",

  -- dev = true,

  enabled = not require("plus.utils").is_server(),

  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },

  config = function()
    local plugutil = require("dap-project-configuration.utils")

    local function detect_lang(cwd, curbuf)
      local handle = vim.uv.fs_scandir(cwd)
      if handle then
        while true do
          local name, type = vim.uv.fs_scandir_next(handle)
          if not name then
            break
          end

          if type == 'file' then
            if name:sub(-4) == ".pro" then
              return "cpp"
            end
          end
        end
      end

      return plugutil.detect_language(cwd, curbuf)
    end

    local plug = require("dap-project-configuration")
    plug.setup({
      detect_language = detect_lang,
      config_templates = {
        rust = function(cwd)
          return [[
local projname = vim.fs.basename(vim.fn.getcwd())

return {
  Debug = {
    prelaunch = {
      p1 = {
        cwd = vim.fn.getcwd(),
        cmd = "cargo",
        args = {"build"},
        env = vim.fn.environ(),
        output = {
          autoscroll = true,
          filetype = "qf",
          close_on_success = true,
        },
        wait = true,
      },
    },
    dap = {
      debug = {
        name = projname,
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.getcwd() .. "/target/debug/" .. projname
        end,
        env = vim.fn.environ(),
      },
    },
    run = {
      launch = "debug",
    },
  },

}
]]
        end,
        cpp = function(cwd)
          return [[
local app = "appname"
local builddir = "]] .. cwd .. [[/build"
local srcdir = "]] .. cwd .. [["
local workdir = "]] .. cwd .. [[/build"

return {
  QMake = {
    prelaunch = {
      p1 = {
        cwd = builddir,
        cmd = "qmake",
        args = { srcdir },
        env = vim.fn.environ(),
        output = {
          target = "buffer",
          reuse = true,
          close_on_success = true,
          stop_on_close = true,
        },
        wait = true,
      },
    },
  },
  Make = {
    prelaunch = {
      p1 = {
        cwd = builddir,
        cmd = "make",
        args = {"-j10"},
        env = vim.fn.environ(),
        wait = true,
        output = {
          target = "buffer",
          close_on_success = false,
          reuse = true,
          autoscroll = true,
          filetype = "qf",
        },
      }
    },
  },
  Clean = {
    prelaunch = {
      p1 = {
        cwd = builddir,
        cmd = "make",
        args = { "clean" },
        env = vim.fn.environ(),
        wait = true,
        output = {
          target = "buffer",
          close_on_success = true,
          autoscroll = true,
          filetype = "qf",
        },
      },
    },
  },
  App = {
    prelaunch = {
      rackmake = {
        cwd = builddir,
        cmd = "make",
        args = {"-j10"},
        env = vim.fn.environ(),
        wait = true,
        output = {
          close_on_success = true,
          autoscroll = true,
        },
      }
    },
    dap = {
     debug = {
        name = app,
        type = "gdb",
        request = "launch",
        cwd = workdir,
        program = function()
          return builddir .. "/" .. app
        end,
        args = {},
        env = vim.tbl_deep_extend("force", {DISPLAY=":0"}, vim.fn.environ()),
      },
    },
    run = {
      launch = "debug",
      output = {
        autoscroll = true,
        close_on_success = false,
      }
    }
  },
}
]]

        end,
        python = function(cwd)
          return [[
return {
  Run = {
    dap = nil,
    run = {
      launch = {
        cwd = "]] .. cwd .. [[",
        cmd = "python",
        args = { "main.py" },
        env = vim.fn.environ(),
        output = {
          autoscroll = true,
          close_on_success = false,
          reuse = true,
          stop_on_close = true,
        }
      },
    },
  },
}
]]

        end,
      },
      ignore_win_to_close = function(wid)
        if vim.wo[wid].winhl == 'Normal:Beacon' then
          return true
        end

        return false
      end,
    })

    vim.keymap.set("n", "<C-r>", "<cmd>ProjectDapRun<CR>", { desc = "Run/Continue DAP" })
    vim.keymap.set("n", "<leader>sr", "<cmd>ProjectDapSelect<CR>", { desc = "Select DAP config" })
    vim.keymap.set("n", "<leader>tr", "<cmd>ProjectDapToggleDap<CR>", { desc = "Toggle Run Dap" })
    vim.keymap.set("n", "<leader>ro", function()
      vim.cmd("tabnew")
      vim.cmd("e " .. vim.fn.getcwd() .. "/.nvim-dap-project-configuration.lua")
    end, { desc = "Open dap config" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "netrw",
      callback = function()
        vim.keymap.set("n", '<C-r>', "<cmd>ProjectDapRun<CR>", { desc = "Run/Continue DAP", remap = true, buffer = true })
      end,
    })
  end,
}

