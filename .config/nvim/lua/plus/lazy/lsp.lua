return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v4.x",

  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },

  config = function()
    local lsp_zero = require('lsp-zero')
    lsp_zero.setup()

    -- lsp_attach is where you enable features that only work
    -- if there is a language server active in the file
    local lsp_attach = function(client, bufnr)
      local opts = {buffer = bufnr}

      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
      vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
      vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
      vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
      vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
      vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
      vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
      vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
      --vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end


    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    lsp_zero.extend_lspconfig({
      sign_text = true,
      lsp_attach = lsp_attach,
      capabilitites = capabilities,
    })

    require('mason').setup({})
    require('mason-lspconfig').setup({
      -- Replace the language servers listed here
      -- with the ones you want to install
      ensure_installed = {'lua_ls', 'rust_analyzer', 'clangd', 'sqls', 'harper_ls', 'bashls', 'pylsp'},
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "vim" }, --"bit", "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          }
        end,
      }
    })

    local cmp = require('cmp')

    cmp.setup({
      sources = {
        {name = 'nvim_lsp'},
      },
      snippet = {
        expand = function(args)
          -- You need Neovim v0.10 to use vim.snippet
          vim.snippet.expand(args.body)
        end,
      },
      preselect = cmp.PreselectMode.Item,
      completion = {
        completeopt = 'menu,menuone,noinsert',
        autocomplete = false, -- disable automatically popping up when typing
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<cr>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        --[[        ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local selected_entry = cmp.get_selected_entry()
            local entries = cmp.get_entries()

            -- Check if only one entry matches and it's fully typed
            if selected_entry == nil and #entries == 1 then
              --if #entries == 1 then
              local completion_item = entries[1]
              if vim.api.nvim_get_current_line():sub(-#completion_item.completion_item.label) == completion_item.completion_item.label then
                cmp.close()  -- Close the popup if it's fully typed
                return
              end
            end

            cmp.confirm({ select = true })  -- Default confirm behavior
          else
            fallback()  -- If no completion is visible, use the fallback (default Enter behavior)
          end
        end, { 'i', 's' }),  -- Map this in insert and select mode
        ]]--
      }),
      ---mapping = cmp.mapping.preset.insert({}),
    })

    -- Automatically close completion if the word is fully typed
    --[[
    vim.api.nvim_create_autocmd("TextChangedI", {
      callback = function()
        if cmp.visible() then
          local selected_entry = cmp.get_selected_entry()
          local entries = cmp.get_entries()

          -- If there is only one match
          if #entries == 1 then
            local completion_item = entries[1]
            -- Get the currently typed word
            local typed_word = vim.api.nvim_get_current_line():sub(vim.fn.col('.') - #completion_item.completion_item.label, vim.fn.col('.') - 1)

            -- If typed word fully matches the only completion, close the popup
            if typed_word == completion_item.completion_item.label then
              cmp.close()
            end
          end
        end
      end
    })
    ]]--

    --[[
    -- Helper function to debounce the automatic completion check
    local function debounce(fn, delay)
      local timer = vim.loop.new_timer()
      return function(...)
        local args = { ... }
        timer:stop() -- Stop any previously running timer
        timer:start(delay, 0, vim.schedule_wrap(function() fn(unpack(args)) end))
      end
    end

    -- Throttle the check for automatically closing the completion
    local check_completion = debounce(function()
      if cmp.visible() then
        local selected_entry = cmp.get_selected_entry()
        local entries = cmp.get_entries()

        -- Only check if there's exactly one entry
        if #entries == 1 then
          local completion_item = entries[1]
          local typed_word = vim.api.nvim_get_current_line():sub(vim.fn.col('.') - #completion_item.completion_item.label, vim.fn.col('.') - 1)

          -- Close the completion menu if the word is fully typed
          if typed_word == completion_item.completion_item.label then
            cmp.close()
          end
        end
      end
    end, 500) -- Delay the check by 200ms to throttle typing events

    -- Set up autocmd to trigger the check after text changes in insert mode
    vim.api.nvim_create_autocmd("TextChangedI", {
      callback = check_completion
    })
    ]]--
  end,
}
