
return {
  "folke/tokyonight.nvim",

  config = function()
    local color = "tokyonight"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    vim.api.nvim_create_user_command("Day", function()
      vim.cmd.colorscheme("tokyonight-day")
    end, {})
    vim.api.nvim_create_user_command("Night", function()
      vim.cmd.colorscheme("tokyonight-day")

      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end, {})
  end,
}

