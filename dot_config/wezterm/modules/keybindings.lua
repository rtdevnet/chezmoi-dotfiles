-- modules/keybindings.lua
local wezterm = require("wezterm")
local action = wezterm.action
local mux = wezterm.mux

local M = {}

function M.get_keys(plugins)
	-- local resurrect = plugins.resurrect.plugin
	-- local w_switcher = plugins.workspace_switcher.plugin
	-- local sessionizer = plugins.sessionizer.plugin

	return {
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
		{
			key = "a",
			mods = "LEADER",
			action = action.AttachDomain("unix"),
		},
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
		{
			key = "d",
			mods = "LEADER",
			action = action.DetachDomain({ DomainName = "unix" }),
		},
		-- -- Resurrect keybindings
		-- {
		-- 	key = "w",
		-- 	mods = "LEADER",
		-- 	action = wezterm.action_callback(function(win, pane)
		-- 		resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
		-- 	end),
		-- },
		-- {
		-- 	key = "r",
		-- 	mods = "LEADER",
		-- 	action = wezterm.action_callback(function(win, pane)
		-- 		resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
		-- 			local type = string.match(id, "^([^/]+)") -- match before '/'
		-- 			id = string.match(id, "([^/]+)$") -- match after '/'
		-- 			id = string.match(id, "(.+)%..+$") -- remove file extention
		-- 			local opts = {
		-- 				relative = true,
		-- 				restore_text = true,
		-- 				on_pane_restore = resurrect.tab_state.default_on_pane_restore,
		-- 			}
		-- 			if type == "workspace" then
		-- 				local state = resurrect.state_manager.load_state(id, "workspace")
		-- 				resurrect.workspace_state.restore_workspace(state, opts)
		-- 			elseif type == "window" then
		-- 				local state = resurrect.state_manager.load_state(id, "window")
		-- 				resurrect.window_state.restore_window(pane:window(), state, opts)
		-- 			elseif type == "tab" then
		-- 				local state = resurrect.state_manager.load_state(id, "tab")
		-- 				resurrect.tab_state.restore_tab(pane:tab(), state, opts)
		-- 			end
		-- 		end)
		-- 	end),
		-- },
		-- {
		-- 	key = "w",
		-- 	mods = "LEADER",
		-- 	action = w_switcher.switch_workspace(),
		-- },
		-- {
		-- 	key = "s",
		-- 	mods = "LEADER",
		-- 	action = sessionizer.show,
		-- },
		-- {
		-- 	key = "S",
		-- 	mods = "LEADER|SHIFT",
		-- 	action = sessionizer.switch_to_most_recent,
		-- },

		-- Sessionizer keybindings
		-- {
		-- 	key = "m",
		-- 	mods = "ALT",
		-- 	action = action.SpawnCommandInNewTab({
		-- 		args = { "wezterm-mux-command", "Sessionizer" },
		-- 	}),
		-- },
		-- {
		-- 	key = "r",
		-- 	mods = "ALT",
		-- 	action = wezterm.action_callback(sessionizer.switch_to_most_recent),
		-- },
	}
end

return M
