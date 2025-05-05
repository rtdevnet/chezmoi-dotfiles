-- modules/fonts.lua
local wezterm = require("wezterm")

local M = {}

function M.get_font()
	local hostname = wezterm.hostname()

	if hostname == "powerbook" then
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
		})
		return font
	elseif hostname == "Workstation" then
		return wezterm.font("JetBrainsMono Nerd Font")
	else
		return wezterm.font("Monaco")
	end
end

return M
