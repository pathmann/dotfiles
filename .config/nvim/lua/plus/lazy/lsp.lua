return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "ray-x/lsp_signature.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        capabilities.textDocument.completion.completionItem.snippetSupport = false

        local lsp_attach = function(client, bufnr)
          local opts = {buffer = bufnr}

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', '<leader>hv', function()
            vim.lsp.buf.clear_references()
            vim.lsp.buf.document_highlight()
          end, { buffer = bufnr, desc = 'Highlight variable' })
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', '<leader>af', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = bufnr, desc = "Apply fix" })

          local lsp_sig = require("lsp_signature")
          vim.keymap.set("i", "<C-g>", function()
            lsp_sig.toggle_float_win()
          end,
          { silent = true, noremap = true, desc = 'toggle signature' })
          lsp_sig.on_attach({}, bufnr)
        end

        local rust_lsp_attach = function(client, bufnr)
          vim.lsp.inlay_hint.enable(true, { bufnr })

          lsp_attach(client, bufnr)
        end

        local clangd_lsp_attach = function(client, bufnr)
          vim.lsp.inlay_hint.enable(true, { bufnr })

          lsp_attach(client, bufnr)
        end

        local is_server = require("plus.utils").is_server()
        local lsplist = {
          "lua_ls",
          "sqls",
          "harper_ls",
          "bashls",
          "pylsp",
        }

        if not is_server then
          for _, lspname in ipairs({"rust_analyzer", "clangd", "slint_lsp"}) do
            table.insert(lsplist, lspname)
          end
        end

        require("mason").setup()
        require("mason-lspconfig").setup({
            automatic_installation = {
              exclude = { "rust_analyzer", }
            },
            ensure_installed = lsplist,
            handlers = {
                function(server_name) -- default handler (optional)
                  if server_name == "rust_analyzer" then
                    return
                  end

                  require("lspconfig")[server_name].setup {
                    capabilities = capabilities,
                    on_attach = lsp_attach,
                  }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")

                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        },
                        on_attach = lsp_attach,
                    }
                end,
                ["harper_ls"] = function()
                  local lspconfig = require("lspconfig")
                  lspconfig.harper_ls.setup {
                    filetypes = {"markdown"},
                    capabilities = capabilities,
                    on_attach = lsp_attach,
                  }
                end,
                ["pylsp"] = function()
                  local lspconfig = require("lspconfig")
                  local flakecfg = nil
                  local flakepath = vim.fn.expand("$HOME/.config/flake8/.flake8")
                  if vim.fn.filereadable(flakepath) == 1 then
                    flakecfg = flakepath
                  end
                  lspconfig.pylsp.setup {
                    capabilities = capabilities,
                    settings = {
                      pylsp = {
                        plugins = {
                          pyflakes = { enabled = false, },
                          pycodestyle = { enabled = false, },
                          flake8 = {
                            enabled = true,
                            config = flakecfg,
                          },
                        },
                      },
                    },
                    on_attach = lsp_attach,
                  }
                end,
                ["clangd"] = function()
                  local lspconfig = require("lspconfig")
                  lspconfig.clangd.setup {
                    capabilities = capabilities,
                    cmd = {
                      "clangd",
                      "--header-insertion=never",
                    },
                    on_attach = clangd_lsp_attach,
                  }
                end,
                --[[ ["rust_analyzer"] = function()
                  local lspconfig = require("lspconfig")
                  lspconfig.rust_analyzer.setup {
                    capabilities = capabilities,
                    on_attach = rust_lsp_attach,
                  }
                end, ]]
				--[[["clangd"] = function()
				  local lspconfig = require("lspconfig")
				  lspconfig.clangd.setup {
					on_attach = function(client, bufnr)
					  client.server_capabilities.signatureHelpProvider = false
					  lsp_attach(client, bufnr)
					end,
				  }
				end,]]--
            }
        })

        local lspcfg = require("lspconfig.configs")
        local lspconfig = require("lspconfig")
        if not lspcfg.qmlls then
          lspcfg.qmlls =  {
            default_config = {
              cmd = {"qmlls6"},
              capabilities = capabilities,
              on_attach = lsp_attach,
              single_file_support = true,
              filetypes = {"qml"},
              root_dir = function(fname)
                return vim.fn.getcwd()
              end,
            }
          }
        end

        lspconfig.qmlls.setup({})

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
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
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
          }, {
            { name = 'buffer' },
          })
        })

        cmp.setup.filetype({ "sql" }, {
          sources = {
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
          }
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
        
        --vim.lsp.set_log_level("debug")

        vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#000000", bg = "#FFD700", bold = true })    -- Black text on bright gold
        vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = "#FFFFFF", bg = "#00BFFF", underline = true })  -- White text on deep sky blue
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = "#FFFFFF", bg = "#FF4500", bold = true })  -- White text on strong orange-red

    end
}
