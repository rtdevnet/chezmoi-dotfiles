-- modules/plugins/smart_splits.lua
local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
	local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

	smart_splits.apply_to_config(config, {
		direction_keys = { "h", "j", "k", "l" },
		modifiers = {
			move = "CTRL",
			resize = "META",
		},
		log_level = "info",
	})
end

return M
