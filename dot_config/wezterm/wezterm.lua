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

-- === Get colors of color_scheme ===
local function get_current_colors()
	local appearance = wezterm.gui.get_appearance()
	local scheme_name = scheme_for_appearance(appearance)

	return wezterm.color.get_builtin_schemes()[scheme_name] or {}
end

-- === Ensure right theme is selected on new workspace ===
wezterm.on("window-config-reloaded", function(window)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local scheme = scheme_for_appearance(appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

-- === Hostname-based font selection ===
local hostname = wezterm.hostname()

if hostname == "powerbook" then
	config.font = wezterm.font("MonoLisa Nerd Font")
elseif hostname == "Workstation" then
	config.font = wezterm.font("JetBrainsMono Nerd Font")
else
	config.font = wezterm.font("Monaco")
end

-- === Window appearance ===
config.window_background_opacity = 0.95
config.macos_window_background_blur = 100
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.font_size = 12.0
config.initial_rows = 160
config.initial_cols = 160
config.use_fancy_tab_bar = false

config.window_frame = {
	font = config.font,
	font_size = 12.0,
}

local colors = get_current_colors()
print("Background color is ", colors.background)

-- === Plugins ===
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		-- theme = scheme_for_appearance(wezterm.gui.get_appearance()),
		component_separators = {
			left = "",
			right = "",
		},
		section_separators = {
			left = "",
			right = "",
		},
		tab_separators = {
			left = "",
			right = "",
		},
		theme_overrides = {
			normal_mode = {
				a = { fg = colors.background, bg = colors.ansi[7] },
				b = { fg = colors.indexed[59], bg = colors.background },
				c = { fg = colors.indexed[59], bg = colors.background },
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
			-- Defining colors for a new key table
			window_mode = {
				a = { fg = colors.background, bg = colors.ansi[6] },
				b = { fg = colors.ansi[6], bg = colors.background },
				c = { fg = colors.foreground, bg = colors.background },
			},
			-- Default tab colors
			tab = {
				active = { fg = colors.ansi[6], bg = colors.background },
				inactive = { fg = colors.indexed[59], bg = colors.background },
				inactive_hover = { fg = colors.ansi[6], bg = colors.background },
			},
		},
	},
	sections = {
		tabline_a = { { Text = " " .. wezterm.nerdfonts.md_alpha_w_box_outline }, "mode" }, -- Left section
		tabline_b = { "workspace" }, -- Left-middle section
		tabline_c = {}, -- Center section
		tab_active = {
			"process",
		},
		tab_inactive = {
			"process",
		},
		tabline_x = {}, -- Right-middle section
		tabline_y = { "hostname", { Text = "|" }, "domain" }, -- Right section
		tabline_z = { "datetime" }, -- Far-right section
	},
})

-- === Keybindings ===
config.leader = { key = "s", mods = "CTRL" }
config.keys = {
	-- 	split_nav("h"),
	-- 	split_nav("j"),
	-- 	split_nav("k"),
	-- 	split_nav("l"),
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
}

smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- if you want to use separate direction keys for move vs. resize, you
	-- can also do this:
	-- direction_keys = {
	-- 	move = { "h", "j", "k", "l" },
	-- 	resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	-- },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})

return config
