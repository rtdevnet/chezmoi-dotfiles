-- modules/ui.lua
local M = {}

function M.apply(config)
	config.window_background_opacity = 0.95
	config.macos_window_background_blur = 100
	config.initial_cols = 150
	config.initial_rows = 50
	config.use_fancy_tab_bar = false

	config.window_frame = {
		font = config.font,
		font_size = 12.0,
	}

	return config
end

return M
