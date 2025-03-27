local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action
local mux = wezterm.mux

-- === Theme based on system appearance ===
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

-- === Ensure right theme is selected on new workspace ===
wezterm.on("window-config-reloaded", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local scheme = scheme_for_appearance(appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

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

-- === Mux Domain ===
config.unix_domains = {
	{
		name = "unix",
	},
}
config.default_gui_startup_args = { "connect", "unix" }

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

-- === Plugins ===
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.apply_to_config(config)

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config, {
	position = "top",
})

-- === Keybindings ===
config.leader = { key = "s", mods = "CTRL" }
config.keys = {
	split_nav("h"),
	split_nav("j"),
	split_nav("k"),
	split_nav("l"),
	-- Tmux keys
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
	{
		key = "z",
		mods = "LEADER",
		action = action.TogglePaneZoomState,
	},
	{
		key = "[",
		mods = "LEADER",
		action = action.ActivateCopyMode,
	},
	{
		key = "c",
		mods = "LEADER",
		action = action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "w",
		mods = "LEADER",
		action = action.ShowTabNavigator,
	},
	{
		key = "&",
		mods = "LEADER",
		action = action.CloseCurrentTab({ confirm = true }),
	},
	-- Attach to muxer
	{
		key = "a",
		mods = "LEADER",
		action = action.AttachDomain("unix"),
	},
	-- Rename current session; analagous to command in tmux
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = action.PromptInputLine({
			description = "Enter new name for session",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
	-- Detach from muxer
	{
		key = "d",
		mods = "LEADER",
		action = action.DetachDomain({ DomainName = "unix" }),
	},
	-- Workspace Switcher plugin
	{
		key = "s",
		mods = "LEADER",
		action = workspace_switcher.switch_workspace(),
	},
	{
		key = "S",
		mods = "LEADER",
		action = workspace_switcher.switch_to_prev_workspace(),
	},
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
