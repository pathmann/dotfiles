local M = {}

M.name = "pylsp"

M.on_server = true

M.setup = function()
  local flakecfg = nil
  local flakepath = vim.fn.expand("$HOME/.config/flake8/.flake8")
  if vim.fn.filereadable(flakepath) == 1 then
    flakecfg = flakepath
  end

  vim.lsp.config(M.name, {
    settings = {
      pylsp = {
        plugins = {
          pyflakes = { enabled = false, },
          pycodestyle = { enabled = false, },
          flake8 = {
            enabled = true,
            config = flakecfg,
          },
          jedi_completion = {
            enabled = true,
            include_params = true,
          },
        },
      },
    },
  })
end

M.on_attach = function()

end

return M
