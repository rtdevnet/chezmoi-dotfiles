return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			integrations = {
				-- lualine = true,
				which_key = true,
				treesitter = true,
				native_lsp = { enabled = true },
				cmp = true,
				gitsigns = true,
				mason = true,
				snacks = true,
				telescope = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
