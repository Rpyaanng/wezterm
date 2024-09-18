local wezterm = require "wezterm"

local M = {}
M.apply_to_config = function(c)
  local font = "Pragmasevka Nerd Font"
  c.font = wezterm.font("Pragmasevka Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" })
  c.color_scheme = "Github Dark (Gogh)"
  local scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
  c.colors = {
    split = scheme.ansi[2],
  }
  c.window_background_opacity = 0.96
  c.inactive_pane_hsb = { brightness = 0.9 }
  c.show_new_tab_button_in_tab_bar = true
end

return M
