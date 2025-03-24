-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- Ensures parsers are updated after installation
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"css",
					"html",
					"latex",
					"norg",
					"scss",
					"svelte",
					"tsx",
					"typst",
					"vue",
					"regex",
					"lua",
					"python",
					"javascript",
					"json",
					"yaml",
					"toml",
				},
				sync_install = false, -- Install parsers asynchronously
				auto_install = true, -- Automatically install missing parsers when entering buffer
				highlight = { enable = true }, -- Enable syntax highlighting
				indent = { enable = true }, -- Enable indentation
			})
		end,
	},
}
