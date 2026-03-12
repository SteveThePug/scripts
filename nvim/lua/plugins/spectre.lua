return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
      { "<leader>sr", function() require("spectre").open_visual({ select_word = true }) end, mode = "v", desc = "Replace Word (Spectre)" },
    },
    opts = {},
  },
}