return {
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.background = "dark"
			vim.cmd("colorscheme oxocarbon")
		end,
	},
	{
		"sainnhe/sonokai",
		opts = {
			sonokai_style = "atlantis",
			sonokai_transparent_background = 1,
			sonokai_enable_italic = true,
		},
	},
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "night",
			transparent = true,
			styles = { comments = { italic = true } },
		},
	},
	{
		"loctvl842/monokai-pro.nvim",
		opts = {
			transparent_background = true,
			filter = "spectrum",
		},
	},
	{ "scottmckendry/cyberdream.nvim" },
	{ "maxmx03/fluoromachine.nvim" },
	{ "rafamadriz/neon" },
}
