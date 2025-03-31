-- @diagnostic disable: undefined-global
local unpack = unpack or table.unpack
local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

return {
	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			-- Define filetypes where cmp should be disabled
			local disabled_filetypes = {
				-- AI assistants
				codecompanion = true,

				-- Common filetypes where completion is often unwanted
				TelescopePrompt = true,
				prompt = true,
				markdown = true,
				gitcommit = true,
				text = true,

				-- Vim-specific
				help = true,
				vim = true,

				-- Terminal-related
				["neo-tree-popup"] = true,
				["dap-repl"] = true,
			}

			cmp.setup({
				enabled = function()
					local buftype = vim.api.nvim_buf_get_option(0, "buftype")
					local filetype = vim.api.nvim_buf_get_option(0, "filetype")

					-- Disable for specific filetypes
					if disabled_filetypes[filetype] then
						return false
					end

					-- Disable for special buffer types
					if buftype == "prompt" or buftype == "nofile" then
						return false
					end

					return true
				end,

				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = vim.schedule_wrap(function(fallback)
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							if entry then
								cmp.confirm({ select = false })
							elseif has_words_before() then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							else
								fallback()
							end
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end),
					-- ["<Tab>"] = vim.schedule_wrap(function(fallback)
					-- 	if cmp.visible() and has_words_before() then
					-- 		cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					-- 	else
					-- 		fallback()
					-- 	end
					-- end),
					-- ["<Tab>"] = cmp.mapping.select_next_item(),
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

						local max_length = 50
						if vim_item.abbr and #vim_item.abbr > max_length then
							vim_item.abbr = vim_item.abbr:sub(1, max_length - 1) .. "…"
						end

						local label_len = #entry.completion_item.label
						if
							(
								entry.source.name == "copilot"
								or entry.source.name == "codeium"
								or entry.source.name == "supermaven"
							) and label_len > 50
						then
							vim_item.kind = "📄 " .. vim_item.kind
						elseif entry.source.name == "luasnip" and label_len > 40 then
							vim_item.kind = "🧩 " .. vim_item.kind
						else
							vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
						end

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
