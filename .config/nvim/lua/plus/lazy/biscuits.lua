return {
  "code-biscuits/nvim-biscuits",

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },

  opts = {
    show_on_start = true,
    cursor_line_only = true,
    min_distance = 0,
    max_file_size = '100kb',

    language_config = {
      python = {
        disabled = true,
      },
      vimdoc = {
        disabled = true,
      },
      query = {
        disabled = true,
      },
    }
  },
}
