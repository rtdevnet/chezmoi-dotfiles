-- modules/appearance.lua
local wezterm = require("wezterm")

local M = {}

function M.scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

function M.scheme_name()
	return M.scheme_for_appearance(wezterm.gui.get_appearance())
end

function M.get_colors()
	local scheme = M.scheme_name()
	return wezterm.color.get_builtin_schemes()[scheme] or {}
end

function M.setup_autoupdate()
	wezterm.on("window-config-reloaded", function(window)
		local overrides = window:get_config_overrides() or {}
		local appearance = window:get_appearance()
		local scheme = M.scheme_for_appearance(appearance)

		if overrides.color_scheme ~= scheme then
			overrides.color_scheme = scheme
			window:set_config_overrides(overrides)
		end

		-- Force tabline refresh with updated color_scheme
		local tabline = require("modules.plugins")
		local colors = M.get_colors()
		tabline.setup_tabline(colors)
	end)
end

return M
