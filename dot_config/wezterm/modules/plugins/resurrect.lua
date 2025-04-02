-- modules/plugins/resurrect.lua
local wezterm = require("wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local M = {}

function M.save(win, pane)
	resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
end

function M.restore(win, pane)
	resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
		-- Once a session is selected, restore it
		local saved_state = resurrect.state_manager.load_state(id)
		if saved_state then
			resurrect.restorer.restore_workspace_state(saved_state)
		else
			wezterm.log_error("Failed to load state: " .. tostring(id))
		end
	end)
end

return M
