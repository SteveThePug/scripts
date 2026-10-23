-- LazyVim already defines all the default groups; only override what differs.
return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>a", group = "ai", mode = { "n", "v" }, icon = { icon = "󰚩", color = "green" } },
        { "<leader>aa", icon = { icon = "󰆍", color = "green" } },
        { "<leader>ac", icon = { icon = "󰧑", color = "orange" } },
        { "<leader>as", icon = { icon = "󰉹", color = "azure" } },
        { "<leader>ad", icon = { icon = "󰅖", color = "red" } },
        { "<leader>at", icon = { icon = "󰆤", color = "yellow" }, mode = { "n", "x" } },
        { "<leader>af", icon = { icon = "󰈙", color = "blue" } },
        { "<leader>av", icon = { icon = "󰒅", color = "cyan" }, mode = "x" },
        { "<leader>ap", icon = { icon = "󰍩", color = "purple" }, mode = { "n", "x" } },
      },
    },
    keys = {
      -- disable LazyVim's default <leader>? so the snacks keymaps picker owns it
      { "<leader>?", false },
    },
  },
}
