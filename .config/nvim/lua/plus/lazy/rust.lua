return {
  "mrcjkb/rustaceanvim",

  version = '^5', -- Recommended

  lazy = false, -- This plugin is already lazy

  init = function()
    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              extraArgs = {
                "--target-dir", "target/rls"
              },
            },
            runnables = {
              extraArgs = {
                "--target-dir",
                "target/rls/",
              },
            },
          },
        },
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = false,
              },
            }
          },
        },
        on_attach = function(client, bufnr)
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
          vim.keymap.set('n', '<leader>af', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = bufnr, desc = "Apply fix" })

          vim.lsp.inlay_hint.enable(true, { bufnr })
        end,
      },
      tools = {
        code_actions = {
          -- ui_select_fallback = true,
        }
      },
      dap = { },
    }
  end,
}
