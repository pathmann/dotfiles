return {
  "rafcamlet/nvim-luapad",

  opts = {
    wipe = false,
  },

  config = function(_, opts)
    require('luapad').setup(opts)

    vim.keymap.set("n", "<leader>lb", function()
      local luapad_buf = nil
      local luapad_tab = nil

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local ok, val = pcall(vim.api.nvim_buf_get_var, buf, "luapad_scratch")
          if ok and val == true then
            luapad_buf = buf

            for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                if vim.api.nvim_win_get_buf(win) == buf then
                  luapad_tab = tab
                  break
                end
              end
              if luapad_tab then
                break
              end
            end
            break
          end
        end
      end

      if luapad_tab then
        vim.api.nvim_set_current_tabpage(luapad_tab)
      elseif luapad_buf then
        vim.cmd("tabnew")
        vim.api.nvim_set_current_buf(luapad_buf)
      else
        vim.cmd("tabnew")
        local auto_buf = vim.api.nvim_get_current_buf()

        require("luapad").init()
        luapad_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_var(luapad_buf, "luapad_scratch", true)

        vim.api.nvim_buf_delete(auto_buf, { force = true })
      end
    end, { desc = "Lua Scratch Buffer" })
  end,
}
