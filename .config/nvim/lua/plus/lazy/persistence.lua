Utils = require("plus.utils")

return {
  "folke/persistence.nvim",

  config = function()
    local per = require("persistence")
    per.setup({})
    per.stop()

    vim.keymap.set("n", "<leader>ql", function()
      per.load()
    end, { desc = "Load session" })
    vim.keymap.set("n", "<leader>qL", function()
      per.select()
    end, { desc = "Select session" })
    vim.keymap.set("n", "<leader>qs", function()
      -- can't use PeristenceSavePre for this because calling save() won't fire the event
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local ok, val = pcall(vim.api.nvim_buf_get_var, bufnr, "nvim-dap-project-configuration")
        if ok and val then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end

      per.save()
    end, { desc = "Store session" })

    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
            local augroup_name = "FoldUpdateOnLsp_" .. buf
            local augroup = vim.api.nvim_create_augroup(augroup_name, { clear = true })
            vim.api.nvim_create_autocmd("LspProgress", {
              group = augroup,
              buffer = buf,
              callback = function(args)
                local kind = args.data and args.data.params and args.data.params.value and args.data.params.value.kind
                if kind == "end" then
                vim.defer_fn(function()
                  Utils.set_local_folding(buf)
                end, 1000)

                vim.api.nvim_del_augroup_by_name(augroup_name)
              end
            end,
          })
        end
      end
    end,
  })
end,
}
