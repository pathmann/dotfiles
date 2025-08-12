local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

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
            print("muhaha")
            local sel = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if sel ~= nil then
              vim.cmd("tabnew " .. sel.path)
            end
          end,
        },
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

    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopePreviewerLoaded",
      callback = function(args)
        vim.wo.wrap = true
      end,
    })
  end
}
