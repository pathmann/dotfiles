return {
  "nvim-lualine/lualine.nvim",

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    sections = {
      lualine_c = {
        "filename",
        function()
          local ok, sel = pcall(require, "dap-project-configuration")
          if ok and sel and sel.current_selection then
            return sel.current_selection
          else
            return ""
          end
        end
      }
    }
  },
}
