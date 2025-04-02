-- modules/fonts.lua
local wezterm = require("wezterm")

local M = {}

function M.get_font()
  local hostname = wezterm.hostname()

  if hostname == "powerbook" then
    return wezterm.font("MonoLisa Nerd Font")
  elseif hostname == "Workstation" then
    return wezterm.font("JetBrainsMono Nerd Font")
  else
    return wezterm.font("Monaco")
  end
end

return M
