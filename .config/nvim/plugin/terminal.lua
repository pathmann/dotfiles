local terminal_state = {}

local function create_floating_terminal(opts)
  opts = opts or {}

  local wintitle = opts.title or "Terminal"

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, buffer is scratch
  end

  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)
  local row = opts.row or math.floor((vim.o.lines - height) / 2)
  local col = opts.col or math.floor((vim.o.columns - width) / 2)

  local win_opts = {
    relative = "editor", -- Relative to the entire editor
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal", -- No number lines or status lines
    border = "rounded" -- Border style (rounded, single, double, etc.)
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  if vim.bo[buf].buftype ~= "terminal" then
    vim.cmd("terminal")
  end

  local function update_winbar(upwin)
    local mode = vim.api.nvim_get_mode().mode
    local mode_map = {
      ["nt"] = "NORMAL",
      ["i"] = "INSERT",
      ["v"] = "VISUAL",
      ["V"] = "V-LINE",
      [""] = "V-BLOCK",
      ["R"] = "REPLACE",
      ["c"] = "COMMAND",
      ["t"] = "TERMINAL"
    }
    local mode_display = mode_map[mode] or "UNKNOWN"

    vim.wo[upwin].winbar = "%#PmenuSel# " .. wintitle .. " %=%#Normal# Mode: " .. mode_display
  end

  local augrp = "Terminal-" .. buf
  vim.api.nvim_create_augroup(augrp, { clear = true })
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = augrp,
    buffer = buf,
    callback = function()
      update_winbar(win)
    end,
  })

  update_winbar(win)

  -- Return buffer and window handles if needed
  return { buf = buf, win = win }
end

local function toggle_terminal(name)
  local reqclosed = false

  for statename, t in pairs(terminal_state) do
    if vim.api.nvim_win_is_valid(t.win) then
      vim.api.nvim_win_hide(t.win)

      if statename == name then
        reqclosed = true
      end
    end
  end

  if reqclosed then
    return
  end

  local buf = -1
  if terminal_state[name] ~= nil then
    buf = terminal_state[name].buf
  end

  terminal_state[name] = create_floating_terminal({ buf = buf, title = "Terminal " .. name })
end

vim.api.nvim_create_user_command("TerminalToggle", function(opts)
  local tname = opts.args
  if tname == "" then
    tname = "1"
  end

  toggle_terminal(tname)

end, { nargs = "?" });

for i=1,5 do
  vim.keymap.set("n", "<leader>t" .. i, function()
    toggle_terminal(i)
  end, { desc = "Toggle Terminal " .. i })
end
