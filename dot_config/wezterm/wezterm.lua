-- wezterm.lua (main entry point)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- === Load custom modules ===
local appearance = require("modules.appearance")
local fonts = require("modules.fonts")
local ui = require("modules.ui")
local keys = require("modules.keybindings")
local plugins = require("modules.plugins")

-- === Basic options ===
config.font = fonts.get_font()
ui.apply(config)

-- === Dynamic color scheme ===
config.color_scheme = appearance.scheme_name()
appearance.setup_autoupdate()

-- === Tabline plugin setup ===
local colors = appearance.get_colors()
plugins.setup_tabline(colors)

-- === Keybindings ===
config.leader = { key = "s", mods = "CTRL" }
config.keys = keys.get_keys()

-- === Smart splits plugin ===
local smart_splits = require("modules.plugins.smart_splits")
smart_splits.apply_to_config(config)

-- ===  Sessionizer plugin ===
local sessionizer = require("modules.plugins.sessionizer")
local home = wezterm.home_dir
sessionizer.plugin.config.paths = home .. "/.repos"
sessionizer.plugin.apply_to_config(config)

return config
