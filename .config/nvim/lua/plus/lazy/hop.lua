return {
  "smoka7/hop.nvim",

  config = function()
    local hop = require('hop')
    hop.setup({
      keys = "asdertovxqpdygfblzhckiurn",
    })

    local directions = require('hop.hint').HintDirection
    vim.keymap.set('n', 'f', function()
      hop.hint_char2({ direction = directions.AFTER_CURSOR})
    end, {remap=true})
    vim.keymap.set('n', 'F', function()
      hop.hint_char2({ direction = directions.BEFORE_CURSOR})
    end, {remap=true})
  end,
}
