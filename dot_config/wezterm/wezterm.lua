local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action

-- === Theme based on system appearance ===
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

-- === Detect if running Neovim in pane ===
local function is_vim(pane)
	-- local process_name = pane:get_foreground_process_name()
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim"
end

-- === Pane navigation via Ctrl-h/j/k/l ===
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

-- === Keybindings ===
config.leader = { key = "s", mods = "CTRL" }
config.keys = {
	split_nav("h"),
	split_nav("j"),
	split_nav("k"),
	split_nav("l"),
	{
		key = "%",
		mods = "LEADER",
		action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = '"',
		mods = "LEADER",
		action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
}

-- === Window appearance ===
config.window_background_opacity = 0.95
config.macos_window_background_blur = 100
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.font_size = 12.0
config.initial_rows = 160
config.initial_cols = 160

config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 11.0,
}

-- === Hostname-based font selection ===
local hostname = wezterm.hostname()

if hostname == "powerbook" then
	config.font = wezterm.font("MonoLisa Nerd Font")
elseif hostname == "Workstation" then
	config.font = wezterm.font("JetBrainsMono Nerd Font")
else
	config.font = wezterm.font("Monaco")
end

return config
