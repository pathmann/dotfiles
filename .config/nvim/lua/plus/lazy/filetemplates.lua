return {
  "otavioschwanck/new-file-template.nvim",

  opts = {
    suffix_as_filetype = true,
    disable_insert = true,
  },

  config = function(_, opts)
    require('new-file-template').setup(opts)
  end,
}
