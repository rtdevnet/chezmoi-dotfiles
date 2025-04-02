-- Construct a table of plugins to load for wezterm
-- adding the plugin config when available
local wezterm = require("wezterm")

local plugin_sources = {
	workspace_switcher = {
		url = "https://github.com/MLFlexer/smart_workspace_switcher.wezterm",
		setup = "apply_to_config", -- or "setup"
	},
	resurrect = {
		url = "https://github.com/MLFlexer/resurrect.wezterm",
		setup = "apply_to_config",
	},
	sessionizer_plugin = {
		url = "https://github.com/mikkasendke/sessionizer.wezterm",
		setup = "apply_to_config",
	},
	smart_splits = {
		url = "https://github.com/mrjones2014/smart-splits.nvim",
		setup = "apply_to_config",
	},
	tabline = {
		url = "https://github.com/michaelbrusegard/tabline.wez",
		setup = "none",
	},
}

local plugins = {}

for name, meta in pairs(plugin_sources) do
	local plugin = wezterm.plugin.require(meta.url)

	-- Load optional config
	local ok, plugin_config = pcall(require, "modules.plugins.configs." .. name)
	if ok and type(plugin_config) == "table" then
		plugin.config = plugin.config or {}
		for k, v in pairs(plugin_config) do
			plugin.config[k] = v
		end
	end

	plugins[name] = {
		plugin = plugin,
		setup_type = meta.setup,
		config = plugin.config or {},
	}
end

return plugins
