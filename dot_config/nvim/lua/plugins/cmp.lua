return {
	-- Completion engine
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" }, -- Optional: Provides additional snippets
		version = "1.*", -- Use a release tag to download prebuilt binaries

		-- Uncomment the following line to build from source (requires Rust nightly)
		-- build = 'cargo build --release',

		opts = {
			keymap = {
				preset = "default",
				["<A-y>"] = require("minuet").make_blink_map()(),
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = { auto_show = false },
				trigger = {
					prefetch_on_insert = false,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "minuet" },
				providers = {
					minuet = {
						name = "minuet",
						module = "minuet.blink",
						score_offset = 8, -- Prioritize minuet suggestions
					},
				},
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
		},
		opts_extend = { "sources.default" },
	},
}
