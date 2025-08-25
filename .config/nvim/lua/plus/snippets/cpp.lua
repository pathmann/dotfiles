local ts_utils = require("nvim-treesitter.ts_utils")

local function not_in_comment_or_string()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local root = ts_utils.get_root_for_position(row, col)
  if not root then return true end

  local function node_contains_cursor(node)
    local start_row, start_col, end_row, end_col = node:range()
    return row >= start_row and row <= end_row and
           col >= start_col and col <= end_col
  end

  local function recurse(n)
    if (n:type() == "comment" or n:type() == "string_content") and node_contains_cursor(n) then
      return true
    end
    for child in n:iter_children() do
      if recurse(child) then
        return true
      end
    end
    return false
  end

  return not recurse(root)
end

local unused_autosnippets = {
  --the closing bracket will be automatically added by nvim-autopairs!
  s("if (", fmt("if ({} {{\n  {}\n}}", {
    i(1, "condition"),
    i(2, ""),
  })),

  --the closing bracket will be automatically added by nvim-autopairs!
  s("while (", fmt("while ({} {{\n  {}\n}}", {
    i(1, "condition"),
    i(2, ""),
  })),

  s({
    trig = "for ",
    condition = not_in_comment_or_string,
  }, fmt([[
for ({}; {}; {}) {{
  {}
}}]], {
    i(1, "int i = 0"),
    i(2, "i < n"),
    i(3, "++i"),
    i(4, ""),
  })),
  s({
    trig = "foreach ",
    condition = not_in_comment_or_string,
  }, fmt([[
for ({} : {}) {{
  {}
}}]], {
    i(1, "const auto& it"),
    i(2, "container"),
    i(3, ""),
  })),

  --the closing bracket will be automatically added by nvim-autopairs!
  s({
    trig = "switch (",
    condition = not_in_comment_or_string,
  }, fmt([[
switch ({} {{
  {}
  default:
    break;
}}]], {
    i(1, ""),
    i(2, ""),
  })),

  s({
    trig = "try ",
    condition = not_in_comment_or_string,
  }, fmt([[
try {{
  {}
}}
catch (const std::exception& e) {{
  {}
}}]], {
    i(1, ""),
    i(2, ""),
  })),
}
return {
  s("class", fmt([[
class {} {{
  public:
    {}();
    ~{}();

  private:
    {}
}};
  ]], {
    i(1, "ClassName"),
    rep(1),
    rep(1),
    i(2, ""),
  })),

  s("struct", fmt([[
struct {} {{
    {}
}};
]], {
  i(1, "StructName"),
  i(2, ""),
  })),

  s("qclass", fmt([[
class {} {{
  Q_OBJECT

  public:
    explicit {}(QObject* parent = nullptr);
    ~{}();

  signals:

  public slots:

  protected slots:

  private:
    {}
}};
  ]], {
    i(1, "ClassName"),
    rep(1),
    rep(1),
    i(2, ""),
  })),

}, {}
