return {
	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					format = function(entry, vim_item)
						-- Source icon						-- Kind icons (for completion item types)
						local kind_icons = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "󰩫",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "󰊄",
						}

						local source_icons = {
							nvim_lsp = "󰒍",
							luasnip = "󰱐",
							buffer = "󰦪",
							path = "󰙅",
							codeium = "󰚩", -- Robot face
							copilot = "", -- GitHub-like icon
							supermaven = "󰠮", -- Brain icon
						}
						-- Add source icon
						-- vim_item.kind = vim_item.kind .. " " .. (source_icons[entry.source.name] or "")
						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
						-- Add source name
						--
						vim_item.menu = string.format("%s %s", source_icons[entry.source.name] or "", ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
							codeium = "[Codeium]",
							copilot = "[Copilot]",
							supermaven = "[Supermaven]",
						})[entry.source.name] or entry.source.name)
						return vim_item
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})
		end,
	},
}
