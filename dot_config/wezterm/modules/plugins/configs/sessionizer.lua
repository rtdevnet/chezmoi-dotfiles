local wezterm = require("wezterm")

return {
	paths = { wezterm.home_dir .. "/.repos" },
	disable_default_keybindings = true,
	show_default = true,
	show_most_recent = true,
	fuzzy = true,
	additional_directories = {
		{ path = wezterm.home_dir .. "/.repos", name = "Repos" },
	},
	show_additional_before_paths = true,
	command_options = { fd_path = "/opt/homebrew/bin/fd" },
}
