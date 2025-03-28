return {
	{
		"olimorris/codecompanion.nvim",
		config = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
				display = {
					chat = {
						show_settings = true,
						render_headers = false,
					},
				},
			},
		},
		keys = {
			{ "<leader>aca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action Palette" },
			{ "<leader>acc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New Chat" },
			{ "<leader>acA", "<cmd>CodeCompanionAdd<cr>", mode = "v", desc = "Add Code" },
			{ "<leader>aci", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline Prompt" },
			{ "<leader>acC", "<cmd>CodeCompanionToggle<cr>", mode = "n", desc = "Toggle Chat" },
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>", group = "ac", icon = "󱚦 ", mode = { "n", "v" } },
			},
		},
	},
}
