return {
	{
		"nvim-lua/plenary.nvim", -- required by codeium
		lazy = false, -- load immediately
	},

	-- Codeium
	{
		"Exafunction/codeium.nvim",
		event = "InsertEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
		enabled = true,
		lazy = true,
	},

	-- Copilot
	{
		"zbirenbaum/copilot.lua",
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

	-- Helper to toggle AI sources
	{
		"nvim-lua/plenary.nvim",
		name = "ai-toggler",
		lazy = false,
		config = function()
			local function disable_all_ai()
				-- Disable Copilot inline suggestions
				pcall(function()
					require("copilot.suggestion").toggle_auto_trigger(false)
				end)
				-- Disable Codeium (by removing its cmp source)
				if package.loaded["cmp"] then
					local cmp = require("cmp")
					cmp.setup.buffer({ sources = {} }) -- clear all sources
				end
				vim.notify("🔇 All AI completions disabled", vim.log.levels.INFO)
			end

			local function enable_codeium()
				disable_all_ai()
				vim.schedule(function()
					if package.loaded["cmp"] then
						local cmp = require("cmp")
						cmp.setup.buffer({
							sources = {
								{ name = "codeium" },
								{ name = "nvim_lsp" },
								{ name = "luasnip" },
								{ name = "buffer" },
								{ name = "path" },
							},
						})
					end
					vim.notify("🤖 Codeium enabled", vim.log.levels.INFO)
				end)
			end

			local function enable_copilot()
				disable_all_ai()
				pcall(function()
					require("copilot.suggestion").toggle_auto_trigger(true)
				end)
				vim.notify("🧠 Copilot enabled", vim.log.levels.INFO)
			end

			-- Keymaps
			-- vim.keymap.set("n", "<leader>ai0", disable_all_ai, { desc = "Disable AI completions" })
			-- vim.keymap.set("n", "<leader>ai1", enable_codeium, { desc = "Enable Codeium" })
			-- vim.keymap.set("n", "<leader>ai2", enable_copilot, { desc = "Enable Copilot" })

			local ai_which_key_object = {
				{ "<leader>ai", group = "AI Tools" },
				{ "<leader>ai0", disable_all_ai, desc = "Disable AI completions" },
				{ "<leader>ai1", enable_codeium, desc = "Enable Codeium" },
				{ "<leader>ai2", enable_copilot, desc = "Enable Copilot" },
			}

			pcall(function()
				require("which-key").add(ai_which_key_object)
			end)
		end,
	},
}
