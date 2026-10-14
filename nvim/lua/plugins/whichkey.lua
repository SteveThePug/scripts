-- LazyVim already defines all the default groups; only override what differs.
return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>a", group = "ai", mode = { "n", "v" } },
      },
    },
    keys = {
      -- disable LazyVim's default <leader>? so the snacks keymaps picker owns it
      { "<leader>?", false },
    },
  },
}
