return {
  {
    "folke/sidekick.nvim",
    opts = {
      -- next edit suggestions need the Copilot LSP
      nes = { enabled = false },
    },
    keys = {
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        mode = { "n", "t", "i", "x" },
        desc = "Sidekick Focus",
      },
      { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Toggle CLI" },
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Toggle Claude",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select({ filter = { installed = true } }) end,
        desc = "Select CLI",
      },
      { "<leader>ad", function() require("sidekick.cli").close() end, desc = "Detach CLI session" },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "n", "x" },
        desc = "Send this",
      },
      { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Send file" },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = "x",
        desc = "Send selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Select prompt",
      },
    },
  },
}
