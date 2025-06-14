return {
  'nvim-telescope/telescope.nvim',

  tag = '0.1.8',

  dependencies =  {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },

  config = function()
    require("telescope").setup({})
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({
        attach_mappings = function(prompt_bufnr, map)
          local action_state = require('telescope.actions.state')
          local actions = require('telescope.actions')

          -- Custom mapping for Enter key to open selected file in a new tab
          map('i', '<CR>', function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if selection ~= nil then
              vim.cmd('tabnew ' .. selection.path)  -- Open in a new tab
            end
          end)

          return true
        end
      })
    end, { desc = "Find files" })

    --vim.keymap.set('n', '<C-p>', builtin.git_files, {})

    vim.keymap.set('n', '<leader>pf', function()
      builtin.grep_string({
        search = vim.fn.input("Grep >"),
        attach_mappings = function(prompt_bufnr, map)
          local action_state = require('telescope.actions.state')
          local actions = require('telescope.actions')

          map('i', '<CR>', function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if selection ~= nil then
              vim.cmd('tabnew ' .. selection.path)  -- Open in a new tab
              vim.cmd(':' .. selection.lnum)
              vim.cmd('norm zz')
            end
          end)

          return true
        end
      })
    end, { desc = "Project find" })

vim.keymap.set('n', '<leader>cf', function()
  local buf_dir = vim.fn.expand('%:p:h')

  builtin.grep_string({
    search = vim.fn.input("Grep (current dir) > "),
    cwd = buf_dir,
    attach_mappings = function(prompt_bufnr, map)
      local action_state = require('telescope.actions.state')
      local actions = require('telescope.actions')

      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection ~= nil then
          vim.cmd('tabnew ' .. selection.path)
          vim.cmd(':' .. selection.lnum)
          vim.cmd('norm zz')
        end
      end)

      return true
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
