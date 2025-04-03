-- wezterm.lua (main entry point)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- === Load Plugins First ===
local plugins = require("modules.plugins")

-- === Load Plugin exception tabline ===
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local tabline_config = require("modules.plugins.configs.tabline")

-- === Load custom modules ===
local appearance = require("modules.appearance")
local fonts = require("modules.fonts")
local ui = require("modules.ui")
local keys = require("modules.keybindings")

-- === Basic options ===
config.font = fonts.get_font()
ui.apply(config)
config.color_scheme = appearance.scheme_name()

-- === Keybindings ===
config.leader = { key = "s", mods = "CTRL" }
config.keys = keys.get_keys(plugins)

-- === Tabline setup (handled separately) ===
wezterm.log_info(tabline_config)
appearance.setup_tabline(tabline, tabline_config)
appearance.setup_autoupdate(tabline, tabline_config)
appearance.setup_workspace_switch_listener(tabline, tabline_config)

-- === Apply other plugin configs ===
for name, entry in pairs(plugins) do
	if name ~= "tabline" then -- skip tabline, handled above
		local plugin = entry.plugin
		local setup_type = entry.setup_type
		local plugin_config = entry.config or {}

		if setup_type == "apply_to_config" and plugin.apply_to_config then
			plugin.apply_to_config(config)
		elseif setup_type == "apply_to_config_with_merge" and plugin.apply_to_config then
			plugin.apply_to_config(config, plugin_config)
		elseif setup_type == "setup" and plugin.setup then
			plugin.setup(plugin_config)
		end
	end
end

-- Test for custom pop-up
-- wezterm.on("gui-startup", function(cmd)
-- 	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
--
-- 	wezterm.sleep_ms(100)
--
-- 	local gui_window = wezterm.gui.gui_windows()[1]
-- 	if not gui_window then
-- 		wezterm.log_error("No GUI window available!")
-- 		return
-- 	end
--
-- 	-- Spawn a new pane to the right (can also use Down/Left)
-- 	local popup_pane = pane:split({
-- 		direction = "Right",
-- 		size = 0.5, -- use smaller if you want more "popup" feel
-- 	})
--
-- 	-- Zoom into the "popup"
-- 	gui_window:perform_action(wezterm.action.TogglePaneZoomState, popup_pane)
--
-- 	-- Send styled welcome message
-- 	popup_pane:send_text("Welcome to WezTerm, Martijn!\n")
-- 	popup_pane:send_text("This pane will close in 3 seconds...\n")
--
-- 	-- Wait before cleanup
-- 	wezterm.sleep_ms(3000)
--
-- 	-- Close the popup pane
-- 	local close_pane_action = wezterm.action.CloseCurrentPane({ confirm = false })
-- 	gui_window:perform_action(close_pane_action, popup_pane)
-- end)

return config
