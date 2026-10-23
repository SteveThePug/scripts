return {
  "TaDaa/vimade",
  event = "WinNew",
  opts = {
    recipe = { "minimalist", { animate = true } },
    fadelevel = 0.8,
    blocklist = {
      snacks_terminal = {
        buf_opts = { ft = "snacks_terminal" },
      },
      sidekick_terminal = {
        buf_opts = { ft = "sidekick_terminal" },
      },
    },
  },
}
