local ts_utils = require("nvim-treesitter.ts_utils")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "o", "r" })
  end,
})

local comment_by_ft = {
  cpp = {
    {
      start = "/*!",
      cont = "* ",
      endtag = "*/",
    },
    {
      start = "///",
      cont = "///",
      endtag = nil,
    },
    {
      start = "/**",
      cont = "* ",
      endtag = "*/",
    },

  },
  rust = {
    {
      start = "///",
      cont = "///",
      endtag = nil,
    },
    {
      start = "/**",
      cont = "* ",
      endtag = "*/",
    }
  },
  python = {
    {
      start = "##",
      cont = "##",
      endtag = nil,
    }
  },
  lua = {
    {
      start = "---",
      cont = "---",
      endtag = nil,
    }
  }
}

local function disableIndents()
  local saved = {
    filetype = vim.bo.filetype,
    indentexpr = vim.bo.indentexpr,
    cindent = vim.bo.cindent,
    autoindent = vim.bo.autoindent,
  }

  vim.bo.filetype = "text"
  vim.bo.indentexpr = ""
  vim.bo.cindent = false
  vim.bo.autoindent = false

  return saved
end

local function reenableIndents(saved)
  vim.bo.filetype = saved.filetype
  vim.bo.indentexpr = saved.indentexpr
  vim.bo.cindent = saved.cindent
  vim.bo.autoindent = saved.autoindent
end

--- @return boolean,string,boolean true if in comment, the continuation prefix and true/false if on last line of comment; false otherwise
local function is_in_doc_comment(ft)
  local rules = comment_by_ft[ft]
  if rules == nil then
    return false, "", false
  end

  local node = ts_utils.get_node_at_cursor()
  while node do
    if node:type() == "comment" then
      local text = vim.treesitter.get_node_text(node, 0)
      local _, _, end_row, _ = node:range()
      local cursor_row = vim.fn.line('.') - 1  -- zero-based

      for _, rule in ipairs(rules) do
        local matchstr = "^%s*" .. rule.start
        if text:match(matchstr) then
          local is_last_line = false
          if rule.endtag and cursor_row == end_row then
            matchstr = rule.endtag .. "%s*$"
            if text:match(matchstr) then
              is_last_line = true
            end
          end
          return true, rule.cont, is_last_line
        end
      end

      return false, "", false
    end
    node = node:parent()
  end
  return false, "", false
end

local function insert_newline_with_comment_prefix(ft)
  local in_doc, contpref = is_in_doc_comment(ft)

  if in_doc then
    local oldset = disableIndents()
    vim.schedule(function()
      reenableIndents(oldset)
    end)

    return "\n" .. contpref
  else
    return "\n"
  end
end

local function open_line_with_comment_prefix(after, ft)
  local in_doc, contpref, last_line = is_in_doc_comment(ft)
  if in_doc then
    local row = vim.fn.line('.')
    local oldset = disableIndents()

    local current_line = vim.api.nvim_get_current_line()
    local cursor_col = vim.fn.col('.') - 1
    local before_cursor = current_line:sub(1, cursor_col)

    local current_indent = before_cursor:match("^%s*") or ""
    local newline = current_indent .. contpref

    if after then
      if last_line then
        reenableIndents(oldset)
        return "o"
      end
      vim.schedule(function()
        vim.api.nvim_buf_set_lines(0, row, row, false, { newline })
        vim.api.nvim_win_set_cursor(0, { row + 1, #newline })
        vim.cmd("startinsert!")
        reenableIndents(oldset)
      end)
    else
      vim.schedule(function()
        vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { newline })
        vim.api.nvim_win_set_cursor(0, { row, #newline })
        vim.cmd("startinsert!")
        reenableIndents(oldset)
      end)
    end
  else
    return after and "o" or "O"
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "lua", "rust", "python" },
  callback = function(args)
    local ft = args.match
    vim.keymap.set("i", "<CR>", function()
      return insert_newline_with_comment_prefix(ft)
    end, { expr = true, buffer = true })

    -- Normal mode: 'o' to open line below with comment prefix
    vim.keymap.set("n", "o", function()
      return open_line_with_comment_prefix(true, ft)
    end, { expr = true, buffer = true })

    -- Normal mode: 'O' to open line above with comment prefix
    vim.keymap.set("n", "O", function()
      return open_line_with_comment_prefix(false, ft)
    end, { expr = true, buffer = true })
  end,
})
