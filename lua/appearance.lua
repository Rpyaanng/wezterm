local wez = require "wezterm"

local M = {}

M.apply_to_config = function(c)
  c.color_scheme = "Catppuccin Mocha"
  local scheme = wez.color.get_builtin_schemes()["Catppuccin Mocha"]
  c.colors = {
    split = scheme.ansi[2],
  }
  c.window_background_opacity = 0.96
  c.inactive_pane_hsb = { brightness = 0.9 }
  c.show_new_tab_button_in_tab_bar = true
end

return M
