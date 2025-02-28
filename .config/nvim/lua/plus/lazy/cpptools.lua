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

local function clang_format(input_str)
  return vim.fn.system("echo ' " .. input_str .. "' | clang-format")
end

---unfortunately clangd seems to not notice PointerAlignment, ReferenceAlignment or DerivcePointerAlignment
local function clangd_format(input_str)
  local buf = vim.api.nvim_create_buf(false, true) -- (listed=false, scratch=true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(input_str, "\n"))
  vim.api.nvim_set_option_value("filetype", "cpp", { buf = buf })
  vim.api.nvim_buf_set_name(buf, "/tmp/test-" .. buf .. ".cpp")

  local params = vim.lsp.util.make_formatting_params({always_format = true})
  params.textDocument.uri = vim.uri_from_bufnr(buf)

  local client = vim.lsp.get_clients({ name = "clangd" })[1]
  if not client or not client.supports_method("textDocument/formatting") then
    print("clangd not found or not supported")
    vim.api.nvim_buf_delete(buf, { force = true })
    return input_str
  end

  if not vim.lsp.buf_is_attached(buf, client.id) then
    vim.lsp.buf_attach_client(buf, client.id)
  end

  -- Send synchronous formatting request
  local result = vim.lsp.buf_request_sync(buf, "textDocument/formatting", params, 1000)

  if result and result[client.id] and result[client.id].result then
    local edits = result[client.id].result

    vim.lsp.util.apply_text_edits(edits, buf, "utf-8")

    local formatted_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    vim.lsp.buf_detach_client(buf, client.id)
    vim.api.nvim_buf_delete(buf, { force = true })

    return table.concat(formatted_lines, "\n")
  else
    vim.lsp.buf_detach_client(buf, client.id)
    vim.api.nvim_buf_delete(buf, { force = true })
    return input_str
  end
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
            output = clang_format(output)
            output = "\n" .. output
            output = output:gsub("}", "}\n")
            output = output:gsub("{", "{\n")
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
