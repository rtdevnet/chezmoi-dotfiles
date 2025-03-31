-- Configuration for CodeCompanion and Which-Key integration
-- CodeCompanion is an AI-powered coding assistant for Neovim that provides:
-- 1. Chat interface for asking questions about code
-- 2. Inline code suggestions and explanations
-- 3. Code refactoring, documentation, and test generation
return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
	},
	{
		"olimorris/codecompanion.nvim",
		lazy = false, -- Load immediately, don't lazy-load
		priority = 100, -- High priority to ensure it loads early
		event = "VeryLazy", -- Still wait for VeryLazy event before initializing
		config = function(_, opts)
			require("codecompanion").setup(opts)
		end,
		dependencies = {
			"nvim-lua/plenary.nvim", -- Utility functions library
			"nvim-treesitter/nvim-treesitter", -- For code parsing and analysis
		},
		opts = {
			strategies = {
				chat = {
					adapter = "anthropic", -- Using Claude AI model for chat functionality
					-- Custom slash commands available in the chat interface
					slash_commands = {
						["file"] = {
							-- Command to include file content in the chat
							callback = "strategies.chat.slash_commands.file",
							description = "Select a file using Snacks Explorer",
							opts = {
								provider = "snacks", -- File picker provider (alternatives: 'default', 'mini_pick', 'fzf_lua')
								contains_code = true,
							},
						},
						["help"] = {
							-- Command to get help on a topic
							callback = "strategies.chat.slash_commands.help",
							description = "Get help on a topic",
							opts = {
								provider = "snacks", -- File picker provider (alternatives: 'default', 'mini_pick', 'fzf_lua')
							},
						},
						["terminal"] = {
							-- Command to run terminal commands
							callback = "strategies.chat.slash_commands.terminal",
							description = "Run terminal commands",
							opts = {
								provider = "snacks", -- File picker provider (alternatives: 'default', 'mini_pick', 'fzf_lua')
							},
						},
						["symbols"] = {
							-- Command to list symbols in the current buffer
							callback = "strategies.chat.slash_commands.symbols",
							description = "List symbols in the current buffer",
							opts = {
								provider = "snacks", -- File picker provider (alternatives: 'default', 'mini_pick', 'fzf_lua')
							},
						},
						["workspace"] = {
							-- Command to list symbols in the current buffer
							callback = "strategies.chat.slash_commands.workspace",
							description = "List symbols in the current workspace",
							opts = {
								provider = "snacks", -- File picker provider (alternatives: 'default', 'mini_pick', 'fzf_lua')
							},
						},
					},
				},
				inline = {
					adapter = "anthropic", -- Using Claude for inline suggestions
					auto_submit = true, -- Automatically submit inline queries
					open_chat = false, -- Don't open chat window for inline queries
				},
			},
			display = {
				chat = {
					show_settings = true, -- Show settings button in chat UI
					render_headers = true, -- Show message headers in chat UI
					auto_scroll = true,
				},
			},
			-- Chat history persistence configuration
			history = {
				enabled = true, -- Enable saving chat history
				save_directory = vim.fn.stdpath("data") .. "/codecompanion/", -- Save in Neovim's data directory
				save_on_exit = true, -- Save history when exiting Neovim
				auto_load_last = true, -- Automatically load last chat on startup
			},
		},
		-- Keymaps for accessing CodeCompanion functionality
		-- All commands are under <leader>ac prefix (except toggle)
		keys = {
			{ "<leader>aca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action Palette" },
			{ "<leader>acc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New Chat" },
			{ "<leader>acA", "<cmd>CodeCompanionAdd<cr>", mode = "v", desc = "Add Code" },
			{ "<leader>aci", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline Prompt" },
			{ "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n", desc = "Toggle Chat" },
			{ "<leader>acr", "<cmd>CodeCompanion /review<cr>", mode = "v", desc = "Code Review" },
			{ "<leader>ace", "<cmd>CodeCompanion /explain<cr>", mode = "v", desc = "Explain Code" },
			{ "<leader>act", "<cmd>CodeCompanion /tests<cr>", mode = "v", desc = "Generate Tests" },
			{ "<leader>acd", "<cmd>CodeCompanion /docs<cr>", mode = "v", desc = "Generate Docs" },
			{ "<leader>acf", "<cmd>CodeCompanion /fix<cr>", mode = "v", desc = "Fix Code Issues" },
			{ "<leader>aco", "<cmd>CodeCompanion /optimize<cr>", mode = "v", desc = "Optimize Code" },
			{ "<leader>acR", "<cmd>CodeCompanion /refactor<cr>", mode = "v", desc = "Refactor Code" },
			{ "<leader>acs", "<cmd>CodeCompanion /simplify<cr>", mode = "v", desc = "Simplify Code" },
			{ "<leader>acC", "<cmd>CodeCompanion /convert<cr>", mode = "v", desc = "Convert Code" },
			{ "<leader>acj", "<cmd>CodeCompanion /json<cr>", mode = "v", desc = "Generate JSON" },
			{ "<leader>acp", "<cmd>CodeCompanion /performance<cr>", mode = "v", desc = "Performance Analysis" },
			{ "<leader>acg", "<cmd>CodeCompanion /generate<cr>", mode = "v", desc = "Generate Implementation" },
			{ "<leader>acv", "<cmd>CodeCompanion /vulnerabilities<cr>", mode = "v", desc = "Security Analysis" },
		},
	},
	{
		-- Which-Key integration to display CodeCompanion commands in a popup menu
		"folke/which-key.nvim",
		opts = function(_, opts)
			if opts.defaults then
				-- Register CodeCompanion category in Which-Key under <leader>ac prefix
				opts.defaults["<leader>ac"] = { name = "CodeCompanion" }
			end
		end,
	},
}
