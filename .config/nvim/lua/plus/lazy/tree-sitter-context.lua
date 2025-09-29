return {
  "nvim-treesitter/nvim-treesitter-context",

  opts = {
    on_attach = function(bufnr)
      return vim.api.nvim_get_option_value("filetype", { buf = bufnr }) ~= "python"
    end,
  }
}
