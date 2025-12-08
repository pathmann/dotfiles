return {
  "taybart/b64.nvim",

  keys = {
    {"<leader>be", function()
      require("b64").encode()
    end, mode = {"n", "v"}, desc = "Encode Base64"},
    {"<leader>bd", function()
      require("b64").decode()
    end, mode = {"n", "v"}, desc = "Decode Base64"}
  }
}
