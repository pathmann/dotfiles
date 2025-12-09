return {
  "let-def/texpresso.vim",

  enabled = not require("plus.utils").is_server(),

  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "tex",
      callback = function()
        vim.keymap.set("n", "<leader>lp", "<cmd>TeXpresso %<CR>", { buffer = true, desc = "LaTeX preview" })
      end,
    })
  end,
}
