return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- linters & formatters
					"ansible-lint",
				},
				run_on_start = true,
				start_delay = 3000, -- optional: wait a bit before auto-install
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				["yaml.ansible"] = { "ansible_lint" },
			}

			-- Auto lint after saving or opening a YAML file
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
				pattern = { "*.yml", "*.yaml" },
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
