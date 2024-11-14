return {
  "folke/twilight.nvim",

  config = function()
    local expand = {
      "function",
      "method",
      "table",
      "if_statement",
    }

    local cppexpand = {
      "function",
      "method",
      "function_declaration",
      "function_definition",
      "method_declaration",
    }

    local opts = {
      expand = expand,
      exclude = {
        "text",
        "jinja",
        "text.jinja",
        "markdown",
      }
    }

    local cppopts = {
      expand = cppexpand,
      exclude = {
        "text",
        "jinja",
        "text.jinja",
        "markdown",
      }
    }

    local tw = require("twilight")
    tw.setup(opts)

    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      callback = function()
        local ft = vim.bo.filetype
        local uopts = opts
        if ft == "cpp" then
          uopts = cppopts
        end

        tw.setup(uopts)

        if vim.tbl_contains(uopts.exclude, ft) then
          tw.disable()
        else
          tw.enable()
        end
      end
    })
  end
}
