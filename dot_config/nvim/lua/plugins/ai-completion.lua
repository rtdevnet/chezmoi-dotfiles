return {
	{
		"nvim-lua/plenary.nvim",
		name = "ai-toggler", -- Plugin name for managing AI completions
		lazy = false, -- Load immediately
		config = function()
			-- Get the completion engine reference
			local cmp = require("cmp")

			-- Define default completion sources (non-AI)
			local default_sources = {
				{ name = "nvim_lsp" }, -- LSP completions
				{ name = "luasnip" }, -- Snippet completions
				{ name = "buffer" }, -- Completions from current buffer
				{ name = "path" }, -- Filesystem path completions
			}

			-- Track the state of our AI completion providers
			local ai_state = {
				copilot = false,
				codeium = false,
				supermaven = false,
			}

			-- List of filetypes where we don't want AI completions
			local ignore_filetypes = {
				"TelescopePrompt",
				"codecompanion",
				"markdown",
				"help",
			}

			-- Check if AI completion is allowed in current buffer
			local function is_ai_allowed()
				return not vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
			end

			-- Create a sources list based on current AI state
			local function build_sources()
				local sources = vim.deepcopy(default_sources)
				-- Add the active AI source (if any) to our sources
				if ai_state.copilot then
					table.insert(sources, { name = "copilot", priority = 700 })
				elseif ai_state.codeium then
					table.insert(sources, { name = "codeium", priority = 700 })
				elseif ai_state.supermaven then
					table.insert(sources, { name = "supermaven", priority = 700 })
				end
				return sources
			end

			-- Update the completion sources for the current buffer
			local function apply_sources_to_buffer()
				if not is_ai_allowed() then
					return
				end
				cmp.setup.buffer({ sources = build_sources() })
			end

			-- Disable all AI completion providers
			local function disable_all_ai()
				-- Reset all AI states to false
				ai_state = { copilot = false, codeium = false, supermaven = false }
				-- Disable Copilot's auto suggestions (if available)
				pcall(function()
					require("copilot.suggestion").toggle_auto_trigger(false)
				end)
				-- Update completion sources to remove AI providers
				apply_sources_to_buffer()
				vim.notify("🔇 All AI completions disabled", vim.log.levels.INFO)
			end

			-- Enable a specific AI completion provider
			local function enable_ai_source(source)
				-- First disable all AI to ensure only one is active
				disable_all_ai()

				vim.schedule(function()
					if source == "copilot" then
						-- Load the Copilot plugins
						require("lazy").load({ plugins = { "copilot.lua", "copilot-cmp" } })
						ai_state.copilot = true
						-- Enable Copilot's auto suggestions
						pcall(function()
							require("copilot.suggestion").toggle_auto_trigger(true)
						end)
						vim.notify("🧠 Copilot enabled", vim.log.levels.INFO)
					elseif source == "codeium" then
						-- Load the Codeium plugin
						require("lazy").load({ plugins = { "codeium.nvim" } })
						ai_state.codeium = true
						vim.notify("🤖 Codeium enabled", vim.log.levels.INFO)
					elseif source == "supermaven" then
						-- Load the Supermaven plugin
						require("lazy").load({ plugins = { "supermaven-nvim" } })
						ai_state.supermaven = true
						vim.notify("💡 Supermaven enabled", vim.log.levels.INFO)
					end

					-- Update completion sources to include the selected AI provider
					apply_sources_to_buffer()
				end)
			end

			-- Update completion sources whenever entering a buffer
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					if cmp ~= nil and cmp.setup then
						apply_sources_to_buffer()
					end
				end,
			})

			-- Register keybindings for toggling AI tools
			local wk = require("which-key")
			wk.add({
				{ "<leader>ai", group = "AI Tools" },
				{
					"<leader>ai0",
					function()
						disable_all_ai()
					end,
					desc = "Disable AI completions",
				},
				{
					"<leader>ai1",
					function()
						enable_ai_source("codeium")
					end,
					desc = "Enable Codeium",
				},
				{
					"<leader>ai2",
					function()
						enable_ai_source("copilot")
					end,
					desc = "Enable Copilot",
				},
				{
					"<leader>ai3",
					function()
						enable_ai_source("supermaven")
					end,
					desc = "Enable Supermaven",
				},
			})
		end,
	},
}
