local M = {}

M.name = "clangd"

M.ensure_installed = "clangd"

M.on_server = false

M.opts = {
  cmd = {
    "clangd",
    "--header-insertion=never",
    "--background-index",
    "--all-scopes-completion",
    "--pch-storage=memory",
  },
}

M.code_actions = function(actions)
  for _, action in ipairs(actions) do
    local header, cpptype = action.title:match('Include "(.+)%.h" for symbol (.+)')
    if header and cpptype and cpptype:startswith('Q') then

      if action.edit then
        for _, change in pairs(action.edit.changes or {}) do
          for _, edit in ipairs(change) do
            if edit.newText:match('#include ".+%.h"\n') then
              edit.newText = "#include <" .. cpptype .. ">\n"
              action.title = "Include <" .. cpptype .. "> for symbol " .. cpptype
            end
          end
        end
      end
    end
  end

  return actions
end

M.on_attach = function(client, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      local curbuf = vim.api.nvim_get_current_buf()

      -- only run on current buffer
      if curbuf ~= bufnr then
        return
      end

      -- mark buffer to avoid infinite loop
      if vim.b._autofix_in_progress then
        return
      end

      -- Get visible lines in current window
      local first = vim.fn.line("w0") - 1
      local last = vim.fn.line("w$") - 1

      -- Filter diagnostics to only those in visible range
      local visible_diags = vim.tbl_filter(function(d)
        return d.lnum >= first and d.lnum <= last
      end, vim.diagnostic.get(bufnr))

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
      end, visible_diags)

      local params = vim.lsp.util.make_range_params()
      params.context = {
        only = { "quickfix" },
        diagnostics = lsp_diagnostics,
      }

      client.request("textDocument/codeAction", params, function(err, actions)
        if err or not actions then return end

        local changed_lines = {}

        for _, action in ipairs(actions) do
          if action.title:lower() == "change '.' to '->'" then
            if action.edit then
              -- track changed lines
              for _, change in pairs(action.edit.changes or {}) do
                for _, edit in ipairs(change) do
                  table.insert(changed_lines, edit.range.start.line)
                end
              end

              vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
            end
          end
        end

        if not vim.tbl_isempty(changed_lines) then
          local hl_ns = vim.api.nvim_create_namespace("cpp_autofix")

          for _, lnum in ipairs(changed_lines) do
            vim.api.nvim_buf_add_highlight(bufnr, hl_ns, "Visual", lnum, 0, -1)
          end

          -- Clear highlights on next save
          vim.api.nvim_create_autocmd({"CursorMoved", "InsertEnter"}, {
            buffer = bufnr,
            once = true,
            callback = function()
              vim.api.nvim_buf_clear_namespace(bufnr, hl_ns, 0, -1)
            end,
          })

          vim.b._autofix_in_progress = true
          vim.schedule(function()
            vim.cmd("write")
            vim.b._autofix_in_progress = false
          end)

          vim.notify("auto fixes applied")
        end
      end, bufnr)
    end,
  })
end

return M
