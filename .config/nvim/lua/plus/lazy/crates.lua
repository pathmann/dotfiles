return {
  "saecki/crates.nvim",

  enabled = not require("plus.utils").is_server(),

  event = { "BufRead Cargo.toml" },

  config = function()
    require("crates").setup({
      completion = {
        cmp = {
          enabled = true,
        },
        crates = {
          enabled = true,
          max_results = 8,
          min_chars = 3,
        },
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      }
    })

    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
      pattern = "Cargo.toml",
      callback = function()
        require("cmp").setup.buffer({ sources = { { name = "crates" } } })
      end,
    })
  end,
}
