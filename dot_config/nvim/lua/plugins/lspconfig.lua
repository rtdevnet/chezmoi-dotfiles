return {
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"pyright",
					"ansiblels",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		opts = {
			servers = {
				-- lua (for Neovim and Wezterm config files)
				lua_ls = {
					-- on_attach = on_attach,
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim", "wezterm" }, -- <== WezTerm support
							},
							workspace = {
								library = {
									vim.fn.expand("~/.config/nvim/lua/wezterm-types"), -- <== wezterm-types folder
								},
								checkThirdParty = false,
							},
						},
					},
				},
				gopls = {
					-- on_attach = on_attach,
					settings = {
						gopls = {
							gofumpt = true,
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							staticcheck = true,
						},
					},
				},
				pyright = {},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			local on_attach = function(_, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end
				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "K", vim.lsp.buf.hover, "Hover info")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
			end

			-- Get default capabilities from cmp_nvim_lsp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			for server, config in pairs(opts.servers) do
				config.on_attach = on_attach
				-- Merge capabilities with any server-specific ones
				config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})
				lspconfig[server].setup(config)
			end
		end,
	},
}
