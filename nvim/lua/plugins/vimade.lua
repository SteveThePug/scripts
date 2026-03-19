return {
	"TaDaa/vimade",
	event = "WinNew",
	opts = {
		recipe = { "minimalist", { animate = true } },
		fadelevel = 0.6,
		blocklist = {
			claude_terminal = {
				buf_opts = { ft = "snacks_terminal" },
			},
		},
	},
}
