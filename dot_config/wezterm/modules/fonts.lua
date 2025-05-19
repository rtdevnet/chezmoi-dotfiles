-- modules/fonts.lua
-- modules/fonts.lua
local wezterm = require("wezterm")

local M = {}

function M.get_font_config()
	return {
		font = wezterm.font({
			family = "Monaspace Neon",
			harfbuzz_features = {
				"calt",
				"liga",
				"dlig",
				"ss01",
				"ss02",
				"ss03",
				"ss04",
				"ss05",
				"ss06",
				"ss07",
				"ss08",
			},
			stretch = "UltraCondensed",
		}),
		font_rules = {
			{
				italic = true,
				font = wezterm.font({
					family = "Monaspace Radon",
					style = "Italic",
					harfbuzz_features = {
						"calt",
						"liga",
						"dlig",
						"ss01",
						"ss02",
						"ss03",
						"ss04",
						"ss05",
						"ss06",
						"ss07",
						"ss08",
					},
					stretch = "UltraCondensed",
				}),
			},
			{
				intensity = "Bold",
				font = wezterm.font({
					family = "Monaspace Krypton",
					weight = "Bold",
					harfbuzz_features = {
						"calt",
						"liga",
						"dlig",
						"ss01",
						"ss02",
						"ss03",
						"ss04",
						"ss05",
						"ss06",
						"ss07",
						"ss08",
					},
					stretch = "UltraCondensed",
				}),
			},
			{
				intensity = "Bold",
				italic = true,
				font = wezterm.font({
					family = "Monaspace Xenon",
					weight = "Bold",
					style = "Italic",
					harfbuzz_features = {
						"calt",
						"liga",
						"dlig",
						"ss01",
						"ss02",
						"ss03",
						"ss04",
						"ss05",
						"ss06",
						"ss07",
						"ss08",
					},
					stretch = "UltraCondensed",
				}),
			},
		},
	}
end

return M
