
return {
  "folke/tokyonight.nvim",

  opts = {
    transparent = true,
  },

  config = function(_, opts)
    require("tokyonight").setup(opts)

    local color = "tokyonight"
    vim.cmd.colorscheme(color)

    vim.api.nvim_create_user_command("Day", function()
      vim.cmd.colorscheme("tokyonight-day")

      vim.uv.spawn("kitten", {
        args = { "@", "--to", "unix:/tmp/mainkitty", "set-colors", "-c", vim.env.HOME .. "/.config/kitty/light-theme.conf" }
      })

      vim.api.nvim_create_autocmd({ 'VimLeave' }, {
        group = vim.api.nvim_create_augroup("KittyThemeReset", { clear = true }),
        callback = function()
          vim.uv.spawn("kitten", {
            args = { "@", "--to", "unix:/tmp/mainkitty", "set-colors", "-c", vim.env.HOME .. "/.config/kitty/dark-theme.conf" }
          })
        end,
      })
    end, {})
    vim.api.nvim_create_user_command("Night", function()
      vim.cmd.colorscheme("tokyonight")

      vim.uv.spawn("kitten", {
        args = { "@", "--to", "unix:/tmp/mainkitty", "set-colors", "-c", vim.env.HOME .. "/.config/kitty/dark-theme.conf" }
      })
    end, {})
  end,
}

