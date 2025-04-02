-- modules/plugins/sessionizer.lua
local wezterm = require("wezterm")
local M = {}

-- We must keep a reference to the plugin after require() to use later
local sessionizer_plugin = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer.wezterm")

M.plugin = sessionizer_plugin

function M.apply_to_config(config)
	local home = wezterm.home_dir
	sessionizer_plugin.apply_to_config(config, {
		paths = {
			home .. "/.repos",
		},
		disable_default_keybindings = false,
	})
end

-- Export the launch function so keybindings can use it

return M
