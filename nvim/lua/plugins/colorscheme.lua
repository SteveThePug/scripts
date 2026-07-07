return {
  { "nyoom-engineering/oxocarbon.nvim", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.opt.background = "dark"
        vim.cmd("colorscheme oxocarbon")
      end,
    },
  },
}
