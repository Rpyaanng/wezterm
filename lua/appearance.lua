local wezterm = require "wezterm"

local M = {}
M.apply_to_config = function(c)
  local font = "GeistMono NF" -- Case sensitive
  c.font = wezterm.font(font)
  c.color_scheme = "Ayu Dark (Gogh)"
  local scheme = wezterm.color.get_builtin_schemes()[c.color_scheme]
  c.colors = {
    split = scheme.ansi[2],
  }
  c.window_background_opacity = 0.96
  c.inactive_pane_hsb = { brightness = 0.9 }
  c.show_new_tab_button_in_tab_bar = true
end

return M
