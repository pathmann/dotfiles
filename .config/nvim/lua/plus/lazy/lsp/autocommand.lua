local Utils = require("plus.lazy.lsp.utils")

local M = {}


local function custom_code_actions(mod, client, bufnr)
  local diags = vim.diagnostic.get(bufnr)

  -- Manually convert to LSP-style diagnostics
  local lsp_diagnostics = vim.tbl_map(function(d)
    return {
      range = {
        start = { line = d.lnum, character = d.col },
        ["end"] = { line = d.end_lnum or d.lnum, character = d.end_col or (d.col + 1) },
      },
      severity = d.severity,
      message = d.message,
      source = d.source,
      code = d.code,
    }
  end, diags)

  local params = vim.lsp.util.make_range_params(0, "utf-8")
  params.context = {
    only = { "quickfix" },
    diagnostics = lsp_diagnostics,
  }

  client.request("textDocument/codeAction", params, function(err, actions)
    if err then
      vim.notify("Error getting code actions: " .. err.message, vim.log.levels.ERROR)
      return
    end

    if not actions or vim.tbl_isempty(actions) then
      vim.notify("No code actions available", vim.log.levels.INFO)
      return
    end

    local newactions = mod.code_actions(actions)

    vim.ui.select(newactions, {
      prompt = "Select Code Action:",
      format_item = function(item)
        return item.title
      end,
    }, function(item)
      if not item then return end
      if item.edit then
        vim.lsp.util.apply_workspace_edit(item.edit, "utf-16")
      end
      if item.command then
        vim.lsp.buf.execute_command(item.command)
      end
    end)
  end)
end

local function code_actions(client, bufnr)
  local serv_mods = Utils.server_modules()
  for _, modname in ipairs(serv_mods) do
    local m = require(modname)
    if m.name == client.name then
      if m.code_actions then
        custom_code_actions(m, client, bufnr)
        return
      end

      break
    end
  end

  print("fallback code actions for client " .. client.name)
  -- fallback
  vim.lsp.buf.code_action()
end

M.create = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("plus-lsp-attach", { clear = true }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      local bufnr = args.buf

      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { buffer = bufnr, desc = "Hover" })
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { buffer = bufnr, desc = "To definition" })
      vim.keymap.set('n', '<leader>gd', function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          vim.notify('No LSP client attached', vim.log.levels.WARN)
          return
        end

        local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

        vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, _, _)
          if err then
            vim.notify('Error while finding definition: ' .. err.message, vim.log.levels.ERROR)
            return
          end
          if not result or (vim.islist(result) and #result == 0) then
            vim.notify('No definition found', vim.log.levels.INFO)
            return
          end

          vim.cmd('tab split')

          local location = vim.islist(result) and result[1] or result

          vim.lsp.util.show_document({
            uri = location.uri or location.targetUri,
            range = location.range or location.targetSelectionRange,
          }, client.offset_encoding)
        end)
      end, { buffer = bufnr, desc = "To definition in new tab" })
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
      vim.keymap.set('n', '<leader>af', function()
        code_actions(client, bufnr)
      end, { buffer = bufnr, desc = "Apply fix" })

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
