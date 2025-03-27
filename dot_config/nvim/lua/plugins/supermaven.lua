return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<S-Tab>",
					accept_word = "<C-Tab>",
				},
				disable_inline_completion = false,
				disable_keymaps = true,
			})
		end,
	},
}
