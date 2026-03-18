return {
  "TaDaa/vimade",
  event = "WinNew",
  opts = {
    recipe = { "minimalist", { animate = true } },
    fadelevel = 0.8,
    blocklist = {
      claude_terminal = {
        buf_opts = { ft = "snacks_terminal" },
      },
    },
  },
}
