-- modules/appearance.lua
local wezterm = require("wezterm")

local function merge_tables(base, override)
	local result = {}

	for k, v in pairs(base or {}) do
		-- if both base and override have a table at this key, merge recursively
		if type(v) == "table" and type(override[k]) == "table" then
			result[k] = merge_tables(v, override[k])
		else
			result[k] = v
		end
	end

	-- copy remaining keys from override
	for k, v in pairs(override or {}) do
		if result[k] == nil then
			result[k] = v
		end
	end

	return result
end

local M = {}

function M.scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		-- wezterm.log_info("Using dark theme")
		return "Catppuccin Mocha"
	else
		-- wezterm.log_info("Using light theme")
		return "Catppuccin Latte"
	end
end

function M.scheme_name()
	local cur_scheme = M.scheme_for_appearance(wezterm.gui.get_appearance())
	wezterm.log_info("Current scheme: " .. cur_scheme)
	return cur_scheme
end

function M.get_colors()
	local scheme = M.scheme_name()
	local schemes = wezterm.color.get_builtin_schemes()
	local colors = schemes[scheme]
	return colors
end

function M.setup_tabline(tabline_plugin, tabline_config)
	local colors = M.get_colors()
	local add_tabline_config = {
		options = {
			theme_overrides = {
				normal_mode = {
					a = { fg = colors.background, bg = colors.ansi[7] },
					b = { fg = colors.indexed and colors.indexed[59] or colors.foreground, bg = colors.background },
					c = { fg = colors.indexed and colors.indexed[59] or colors.foreground, bg = colors.background },
				},
				copy_mode = {
					a = { fg = colors.background, bg = colors.ansi[4] },
					b = { fg = colors.ansi[4], bg = colors.background },
					c = { fg = colors.foreground, bg = colors.background },
				},
				search_mode = {
					a = { fg = colors.background, bg = colors.ansi[3] },
					b = { fg = colors.ansi[3], bg = colors.background },
					c = { fg = colors.foreground, bg = colors.background },
				},
				window_mode = {
					a = { fg = colors.background, bg = colors.ansi[6] },
					b = { fg = colors.ansi[6], bg = colors.background },
					c = { fg = colors.foreground, bg = colors.background },
				},
				tab = {
					active = { fg = colors.ansi[6], bg = colors.background },
					inactive = {
						fg = colors.indexed and colors.indexed[59] or colors.foreground,
						bg = colors.background,
					},
					inactive_hover = { fg = colors.ansi[6], bg = colors.background },
				},
			},
		},
	}
	local merged_tabline_config = merge_tables(tabline_config, add_tabline_config)
	tabline_plugin.setup(merged_tabline_config)
end

function M.setup_autoupdate(tabline_plugin, tabline_config)
	wezterm.on("window-config-reloaded", function(window)
		local overrides = window:get_config_overrides() or {}
		local appearance = window:get_appearance()
		local scheme = M.scheme_for_appearance(appearance)

		if overrides.color_scheme ~= scheme then
			overrides.color_scheme = scheme
			window:set_config_overrides(overrides)
		end

		M.setup_tabline(tabline_plugin, tabline_config)
		wezterm.log_info("Ran autoupdate")
	end)
end

function M.setup_workspace_switch_listener(tabline_plugin, tabline_config)
	wezterm.on("smart_workspace_switcher.workspace_switcher.started", function(window, path, label)
		local overrides = window:get_config_overrides() or {}
		-- local scheme = M.scheme_name_for_window(window)
		local appearance = window:get_appearance()
		local scheme = M.scheme_for_appearance(appearance)

		if overrides.color_scheme ~= scheme then
			wezterm.log_info("[Workspace Switch] Applying scheme:", scheme)
			overrides.color_scheme = scheme
			window:set_config_overrides(overrides)
		end

		M.setup_tabline(tabline_plugin, tabline_config)
	end)
end

return M
