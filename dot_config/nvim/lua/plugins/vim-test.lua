return {
	"vim-test/vim-test",
	dependencies = {
		"preservim/vimux",
	},

	config = function()
		local test_which_key_object = {
			{ "<leader>t", group = "Test Tools" },
			{ "<leader>tt", "<cmd>TestNearest<CR>" },
			{ "<leader>tT", "<cmd>TestFile<CR>" },
			{ "<leader>ta", "<cmd>TestSuite<CR>" },
			{ "<leader>tl", "<cmd>TestLast<CR>" },
			{ "<leader>tg", "<cmd>TestVisit<CR>" },
		}
		pcall(function()
			require("which-key").add(test_which_key_object)
		end)
		vim.cmd("let test#strategy = 'vimux'")
	end,
}
