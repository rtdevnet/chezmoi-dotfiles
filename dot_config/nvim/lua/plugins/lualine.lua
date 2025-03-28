return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
	event = "VeryLazy",
	config = function()
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				icons_enabled = true,
				section_separators = "",
				component_separators = "",
				disabled_filetypes = { "NvimTree", "lazy", "TelescopePrompt" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } }, -- 0=just file, 1=rel path, 2=abs
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
