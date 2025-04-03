-- tabline plugin config
return {
	options = {
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		tab_separators = { left = "", right = "" },
	},
	sections = {
		tabline_a = { { Text = " " .. require("wezterm").nerdfonts.md_alpha_w_box_outline }, "mode" },
		tabline_b = { "workspace" },
		tabline_c = {},
		tab_active = { "process" },
		tab_inactive = { "process" },
		tabline_x = {},
		tabline_y = { "hostname", { Text = "|" }, "domain" },
		tabline_z = { "datetime" },
	},
}
