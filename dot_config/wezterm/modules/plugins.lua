-- modules/plugins.lua
local wezterm = require("wezterm")
local M = {}

function M.setup_tabline(colors)
  local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

  tabline.setup({
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      tab_separators = { left = "", right = "" },
      theme_overrides = {
        normal_mode = {
          a = { fg = colors.background, bg = colors.ansi[7] },
          b = { fg = colors.indexed and colors.indexed[59] or colors.foreground, bg = colors.background },
          c = { fg = colors.indexed and colors.indexed[59] or colors.foreground, bg = colors.background },
        },
        copy_mode = {
          a = { fg = colors.background, bg = colors.ansi[4] },
          b = { fg = colors.ansi[4], bg = colors.background },
          c = { fg = colors.foreground, bg = colors.background },
        },
        search_mode = {
          a = { fg = colors.background, bg = colors.ansi[3] },
          b = { fg = colors.ansi[3], bg = colors.background },
          c = { fg = colors.foreground, bg = colors.background },
        },
        window_mode = {
          a = { fg = colors.background, bg = colors.ansi[6] },
          b = { fg = colors.ansi[6], bg = colors.background },
          c = { fg = colors.foreground, bg = colors.background },
        },
        tab = {
          active = { fg = colors.ansi[6], bg = colors.background },
          inactive = { fg = colors.indexed and colors.indexed[59] or colors.foreground, bg = colors.background },
          inactive_hover = { fg = colors.ansi[6], bg = colors.background },
        },
      },
    },
    sections = {
      tabline_a = { { Text = " " .. wezterm.nerdfonts.md_alpha_w_box_outline }, "mode" },
      tabline_b = { "workspace" },
      tabline_c = {},
      tab_active = { "process" },
      tab_inactive = { "process" },
      tabline_x = {},
      tabline_y = { "hostname", { Text = "|" }, "domain" },
      tabline_z = { "datetime" },
    },
  })
end

return M
