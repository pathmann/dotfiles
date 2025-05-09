local Utils = require("plus.lazy.lsp.utils")

local M = {}

M.create = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("plus-lsp-attach", { clear = true }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      local bufnr = args.buf

      vim.lsp.inlay_hint.enable(true, { bufnr })

      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { buffer = bufnr, desc = "Hover" })
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { buffer = bufnr, desc = "To definition" })
      vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { buffer = bufnr, desc = "To declaration" })
      vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { buffer = bufnr, desc = "To implementation" })
      vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { buffer = bufnr, desc = "To type" })
      vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { buffer = bufnr, desc = "Find references" })
      -- vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { buffer = bufnr, desc = "Signature help" })
      vim.keymap.set('n', '<leader>hv', function()
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end, { buffer = bufnr, desc = 'Highlight variable' })
      vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', { buffer = bufnr, desc = "Rename" })
      -- vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
      vim.keymap.set('n', '<leader>af', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = bufnr, desc = "Apply fix" })

      local lsp_sig = require("lsp_signature")
      vim.keymap.set("i", "<C-g>", function()
        lsp_sig.toggle_float_win()
      end,
      { buffer = bufnr, silent = true, noremap = true, desc = 'Toggle signature' })
      lsp_sig.on_attach({}, bufnr)

      local serv_mods = Utils.server_modules()
      for _, modname in ipairs(serv_mods) do
        local m = require(modname)
        if m.name == client.name then
          m.on_attach(client, bufnr)
          break
        end
      end
    end,
  })
end

return M
