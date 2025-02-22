local function detect_csv_delimiter(bufnr, defdelim)
  local delimiters = {",", ";", "\t", "|"}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local line = ""
  for _, l in ipairs(lines) do
    if l:match("%S") then
      line = l
      break
    end
  end

  if line == "" then return defdelim end

  local best_delimiter, max_fields = defdelim, 0
  for _, delim in ipairs(delimiters) do
    local fields = vim.split(line, delim, {plain = true})
    if #fields > max_fields then
      max_fields, best_delimiter = #fields, delim
    end
  end

  return best_delimiter
end

return {
  "hat0uma/csvview.nvim",

  opts = {
    parser = {
      comments = { "#", "//" },
      delimiter = {
        default = ";"
      },
    },
    keymaps = {
      -- Text objects for selecting fields
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      -- Excel-like navigation:
      -- Use <Tab> and <S-Tab> to move horizontally between fields.
      -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
      -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      jump_next_row = { "<Enter>", mode = { "n", "v" } },
      jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
    },
  },

  init = function(plugin)
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = {"*.csv"},
      callback = function(ev)
        local delim = detect_csv_delimiter(ev.buf, plugin.opts.parser.delimiter.default)
        vim.cmd("CsvViewEnable delimiter=" .. delim)
      end,
    })

  end,

  config = function(_, opts)
    require("csvview").setup(opts)
  end,

  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
}
