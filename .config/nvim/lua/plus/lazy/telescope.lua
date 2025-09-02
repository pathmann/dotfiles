local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

local open_externally = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  if entry and entry.path then
    local path = entry.path
    local cmd
    if vim.fn.has("macunix") == 1 then
      cmd = { "open", path }
    elseif vim.fn.has("unix") == 1 then
      cmd = { "xdg-open", path }
    elseif vim.fn.has("win32") == 1 then
      cmd = { "start", path }
    end
    if cmd then
      vim.fn.jobstart(cmd, { detach = true })
    end
  end
end

return {
  'nvim-telescope/telescope.nvim',

  tag = '0.1.8',

  dependencies =  {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },

  opts = {
    defaults = {
      mappings = {
        n = {
          ["<leader><CR>"] = function(prompt_bufnr)
            local sel = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if sel ~= nil then
              vim.cmd("tabnew " .. sel.path)

              local lnum = sel.lnum or sel.row
              local col  = sel.col or 1
              if lnum then
                vim.api.nvim_win_set_cursor(0, { lnum, math.max(col - 1, 0) })
              end
            end
          end,
          ["x"] = open_externally,
        },
        i = {
          ["<C-x>"] = open_externally,
        }
      }
    }
  },

  config = function(_, opts)
    require("telescope").setup(opts)
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files"})

    vim.keymap.set('n', '<leader>pf', function()
      builtin.grep_string({
        search = vim.fn.input("Grep >"),
        additional_args = function()
          return { "--smart-case" }
        end,
      })
    end, { desc = "Project find" })

    vim.keymap.set('n', '<leader>cf', function()
      local buf_dir = vim.fn.expand('%:p:h')

      builtin.grep_string({
        search = vim.fn.input("Grep (current dir) > "),
        cwd = buf_dir,
        additional_args = function()
          return { "--smart-case" }
        end,
      })
    end, { desc = "Find in current dir" })

    vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = "List open buffers" }) 

    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopePreviewerLoaded",
      callback = function(args)
        vim.wo.wrap = true
      end,
    })
  end
}
