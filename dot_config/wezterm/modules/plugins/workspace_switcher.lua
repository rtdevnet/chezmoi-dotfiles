-- modules/plugins/workspace_switcher.lua
local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
	local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

	workspace_switcher.apply_to_config(config)
end

return M
