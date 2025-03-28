return {
	-- {
	-- 	"nvim-lua/plenary.nvim", -- required by codeium
	-- 	lazy = false, -- load immediately
	-- },

	-- Helper to toggle AI sources
	{
		"nvim-lua/plenary.nvim",
		name = "ai-toggler",
		lazy = false,
		config = function()
			local default_cmp_sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}

			local function disable_all_ai()
				-- Disable Copilot inline suggestions
				pcall(function()
					require("copilot.suggestion").toggle_auto_trigger(false)
				end)

				-- Reset CMP to default sources (no AI)
				if package.loaded["cmp"] then
					local cmp = require("cmp")
					cmp.setup.buffer({ sources = vim.deepcopy(default_cmp_sources) })
				end

				vim.notify("🔇 All AI completions disabled", vim.log.levels.INFO)
			end

			local function enable_codeium()
				disable_all_ai()
				vim.schedule(function()
					require("lazy").load({ plugins = { "codeium.nvim" } })
					if package.loaded["cmp"] then
						local cmp = require("cmp")
						local sources = vim.deepcopy(default_cmp_sources)
						table.insert(sources, { name = "codeium" })
						cmp.setup.buffer({ sources = sources })
						vim.notify("🤖 Codeium enabled", vim.log.levels.INFO)
					end
				end)
			end

			local function enable_copilot()
				disable_all_ai()
				vim.schedule(function()
					require("lazy").load({ plugins = { "copilot.lua", "copilot-cmp" } })
					if package.loaded["cmp"] then
						local cmp = require("cmp")
						local sources = vim.deepcopy(default_cmp_sources)
						table.insert(sources, { name = "copilot" })
						cmp.setup.buffer({ sources = sources })
						vim.notify("🧠 Copilot enabled", vim.log.levels.INFO)
					end
				end)
			end

			local function enable_supermaven()
				disable_all_ai()
				vim.schedule(function()
					require("lazy").load({ plugins = { "supermaven-nvim" } })
					if package.loaded["cmp"] then
						local cmp = require("cmp")
						local sources = vim.deepcopy(default_cmp_sources)
						table.insert(sources, { name = "supermaven" })
						cmp.setup.buffer({ sources = sources })
						vim.notify("🧠 Supermaven enabled", vim.log.levels.INFO)
					end
				end)
			end

			local ai_which_key_object = {
				{ "<leader>ai", group = "AI Tools" },
				{ "<leader>ai0", disable_all_ai, desc = "Disable AI completions" },
				{ "<leader>ai1", enable_codeium, desc = "Enable Codeium" },
				{ "<leader>ai2", enable_copilot, desc = "Enable Copilot" },
				{ "<leader>ai3", enable_supermaven, desc = "Enable Supermaven" },
			}

			pcall(function()
				require("which-key").add(ai_which_key_object)
			end)
		end,
	},
}
