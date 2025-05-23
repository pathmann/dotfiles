return {
   "3rd/image.nvim",
   
   enabled = not vim.loop.os_uname().sysname:lower():startswith("windows"),

    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239

    opts = {
      processor = "magick_cli",
      window_overlap_clear_enabled = true,
    },
}
