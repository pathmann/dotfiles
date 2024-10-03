function GetProjectCommand()
  local cwd = vim.fn.getcwd()  -- Get the current working directory
  local run_command_file = cwd .. '/.nvim-runcommand.lua'

  -- Check if the custom run command Lua file exists
  if vim.fn.filereadable(run_command_file) == 1 then
    local loaded_func, err = loadfile(run_command_file)  -- Load the Lua file
    if loaded_func then
      local custom_command = loaded_func()  -- Execute the Lua code
      if type(custom_command) == "string" or type(custom_command) == "function" then
        return custom_command  -- Return the result
      else
        print("Command file neither did return a string or a function")
      end
    else
      print("Error loading .nvim-runcommand.lua: " .. err)  -- Print error if any
    end
  end

  -- Check for specific project files and types
  local files = vim.fn.readdir(cwd)
  for _, file in ipairs(files) do
    if file:match('%main.py$') then
      return "python main.py"
    elseif file:match('%.rs$') then
      return "cargo run"
    end
  end

  -- Check for specific configuration files
  if vim.fn.filereadable(cwd .. '/Cargo.toml') == 1 then
    return "cargo run"
  --elseif vim.fn.filereadable(cwd .. '/requirements.txt') == 1 then
  --  return "python -m myscript"
  end

  return "ls"  -- Default command
end

function RunFunctionOrString(terminalid, cmd) 
  if type(cmd) == "string" then
    vim.fn.chansend(terminalid, cmd .. '\n')
  elseif type(cmd) == "function" then
    cmd(terminalid)
  else
    print("Invalid runcommand type")
  end
end

function OpenNamedTermAndRun()
  local projcmd = GetProjectCommand()
  --print("proj cmd has type " .. type(projcmd))
  -- Loop through all open windows
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ok, is_run_term = pcall(vim.api.nvim_buf_get_var, buf, 'is_run_term')

    if ok and is_run_term == 1 then
      vim.api.nvim_set_current_win(win)     -- Switch to that window
      RunFunctionOrString(vim.b.terminal_job_id, projcmd)
      return
    end
  end

  -- If no named terminal is found, open a new vsplit with a terminal
  vim.cmd('belowright split')                        -- Open vsplit
  vim.cmd('terminal')                      -- Open terminal in the vsplit
  local term_buf = vim.api.nvim_get_current_buf()  -- Get the buffer of the newly opened terminal
  vim.api.nvim_buf_set_var(term_buf, 'is_run_term', 1)  -- Mark this terminal as the named terminal
  RunFunctionOrString(vim.b.terminal_job_id, projcmd)
end


