local function switchHeaderSource()
  -- Get the current file name
  local filename = vim.fn.expand('%:t')         -- Current file name with extension
  local extension = vim.fn.expand('%:e')        -- Current file extension
  local basename = vim.fn.expand('%:t:r')       -- Base name of the file without extension
  local filepath = vim.fn.expand('%:p:h')       -- Path to the current file

  -- Check if the current file is a C++ source file or a header file
  if extension == 'cpp' then
    -- If the file is a .cpp, try to switch to the .h or .hpp file
    if vim.fn.filereadable(filepath .. '/' .. basename .. '.h') == 1 then
      vim.cmd('edit ' .. filepath .. '/' .. basename .. '.h')
    elseif vim.fn.filereadable(filepath .. '/' .. basename .. '.hpp') == 1 then
      vim.cmd('edit ' .. filepath .. '/' .. basename .. '.hpp')
    end
  elseif extension == 'h' or extension == 'hpp' then
    -- If the file is a header (.h or .hpp), switch to the .cpp file
    if vim.fn.filereadable(filepath .. '/' .. basename .. '.cpp') == 1 then
      vim.cmd('edit ' .. filepath .. '/' .. basename .. '.cpp')
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.keymap.set("n", "<F4>", switchHeaderSource, { noremap = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.keymap.set("n", "<F4>", switchHeaderSource, { noremap = true, silent = true })
  end,
})

