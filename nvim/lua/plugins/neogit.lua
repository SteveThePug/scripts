return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      { "<leader>gg", function() require("neogit").open() end, desc = "Neogit" },
      { "<leader>gc", function() require("neogit").open({ "commit" }) end, desc = "Neogit Commit" },
      { "<leader>gl", function() require("neogit").open({ "log" }) end, desc = "Neogit Log" },
      { "<leader>gp", function() require("neogit").open({ "push" }) end, desc = "Neogit Push" },
    },
    opts = {
      integrations = {
        diffview = true,
      },
    },
  },
}