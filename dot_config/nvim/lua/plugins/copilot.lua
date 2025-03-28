return {
	-- Copilot
	{
		"zbirenbaum/copilot.lua",
		dependencies = { "zbirenbaum/copilot-cmp" },
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = false,
					auto_trigger = false,
				},
				panel = { enabled = false },
			})
		end,
		enabled = true,
		lazy = true,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
