local wezterm = require("wezterm")
local config = wezterm.config_builder()

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

local function is_vim(pane)
	local process_name = pane:get_foreground_process_name()
	return process_name == "nvim"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(key)
	return {
		key = key,
		mods = "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				win:perform_action({ SendKey = { key = key, mods = "CTRL" } }, pane)
			else
				win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
			end
		end),
	}
end

config.leader = {
	key = "s",
	mods = "CTRL",
}

config.keys = {
	split_nav("h"),
	split_nav("j"),
	split_nav("k"),
	split_nav("l"),
}

-- config.keys = {
-- 	{ key = "%", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
-- 	{ key = '"', mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
-- 	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
-- 	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
-- 	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
-- 	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
-- 	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
-- 	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
-- }

config.window_background_opacity = 0.95
config.macos_window_background_blur = 100

-- config.font = wezterm.font 'OverpassM Nerd Font'
-- config.font = wezterm.font 'Mononoki Nerd Font'
-- config.font = wezterm.font 'MonoLisa Nerd Font'
-- config.font = wezterm.font 'MonospiceKr Nerd Font'
-- config.font = wezterm.font 'Lilex Nerd Font'

config.font = wezterm.font_with_fallback({
	{ family = "MonoLisa Nerd Font", weight = "Light", stretch = "UltraCondensed" },
	"JetBrainsMono Nerd Font",
})
config.font_size = 12.0
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 11.0,
}

config.initial_rows = 160
config.initial_cols = 160

return config
