return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		opts = {
			terminal = {
				provider = "snacks",
				snacks_win_opts = {
					relative = "win",
					position = "bottom",
					height = 0.3,
					split_width_percentage = 0.99,
				},
			},
			diff_opts = {
				layout = "vertical",
				open_in_new_tab = true,
				keep_terminal_focus = true,
			},
		},
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil" },
			},
			-- Diff management
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},

	-- Disabled: unmaintained
	{
		"greggh/claude-code.nvim",
		enabled = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			position = "float",
			float_opts = {
				relative = "win",
				width = "80%",
				height = "80%",
				row = "center",
				col = "center",
				border = "rounded",
			},
		},
		keys = {
			{ "<leader>a", nil, desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>ar", "<cmd>ClaudeCodeResume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCodeContinue<cr>", desc = "Continue Claude" },
		},
	},
}
