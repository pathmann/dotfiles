return {
  "https://git.sr.ht/~swaits/scratch.nvim",
  lazy = true,
  keys = {
    { "<leader>sb", "<cmd>tabnew<cr><cmd>Scratch<cr>", desc = "Scratch Buffer", mode = "n" },
  },
  cmd = {
    "Scratch",
    "ScratchSplit",
  },
  opts = {},
}
