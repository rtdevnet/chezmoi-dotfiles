-- wezterm.lua (main entry point)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- === Load Plugins First ===
local plugins = require("modules.plugins")

-- === Load Plugin exception tabline ===
local tabline = plugins.tabline.plugin
local tabline_config = require("modules.plugins.tabline")

-- === Load custom modules ===
local appearance = require("modules.appearance")
local fonts = require("modules.fonts")
local ui = require("modules.ui")
local keys = require("modules.keybindings")

-- === Basic options ===
config.font = fonts.get_font()
ui.apply(config)
-- config.color_scheme = appearance.scheme_name()

-- === Keybindings ===
config.leader = { key = "s", mods = "CTRL" }
config.keys = keys.get_keys(plugins)

-- === Tabline setup (handled separately) ===
wezterm.log_info(tabline_config)
-- appearance.setup_tabline(tabline, tabline_config)
appearance.setup_autoupdate(tabline, tabline_config)

-- === Apply other plugin configs ===
for name, entry in pairs(plugins) do
    if name ~= "tabline" then -- skip tabline, handled above
        local plugin = entry.plugin
        local setup_type = entry.setup_type
        local plugin_config = entry.config or {}

        if setup_type == "apply_to_config" and plugin.apply_to_config then
            plugin.apply_to_config(config)
        elseif setup_type == "setup" and plugin.setup then
            plugin.setup(plugin_config)
        end
    end
end

return config
