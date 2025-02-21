local function createClassDeclaration()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local cpptools = require("nt-cpp-tools.internal")

  local cursor_node = ts_utils.get_node_at_cursor()

  while cursor_node do
    if cursor_node:type() == 'class_specifier' then
      ts_utils.goto_node(cursor_node)

      local start_row, _, end_row, _ = cursor_node:range()
      cpptools.imp_func(start_row +1, end_row +1)
      vim.cmd("normal! G")
      return
    end

    cursor_node = cursor_node:parent()
  end

  print("No class definition found under the cursor.")
end

return {
  "Badhi/nvim-treesitter-cpp-tools",

  dependencies = {
    "nvim-treesitter/nvim-treesitter"
  },

  config = function()
    local plug = require("nt-cpp-tools")
    plug.setup({
      preview = {
        quit = "q", -- optional keymapping for quit preview
        accept = "<tab>", -- optional keymapping for accept preview
      },
      header_extension = "h", -- optional
      source_extension = "cpp", -- optional
      custom_define_class_function_commands = { -- optional
        TSCppDefineClassFunc = {
          output_handle = function(output, ctx)
            output = output:gsub("\n{\n}\n", " {\n\n}\n\n")
            require("nt-cpp-tools.output_handlers").get_preview_and_apply()(output, ctx)
          end
        },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "cpp",
      callback = function()
        vim.keymap.set("n", "<leader>md", function()
          createClassDeclaration()
        end, { noremap = true, silent = true, desc = "Make definition" })

        vim.keymap.set("n", "<leader>mD", "<cmd>TSCppDefineClassFunc<cr>", { noremap = true, silent = true, desc = "Make function definition" })
        vim.keymap.set("v", "<leader>mD", ":TSCppDefineClassFunc<cr>", { noremap = true, silent = true, desc = "Make function definition" })
      end,
    })

  end,
}
