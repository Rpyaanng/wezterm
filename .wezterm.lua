local wez = require "wezterm"
local utils = require "lua.utils"

local appearance = require "lua.appearance"
local bar = wez.plugin.require "https://github.com/adriankarlen/bar.wezterm"
local mappings = require "lua.mappings"

local c = {}

if wez.config_builder then
  c = wez.config_builder()
end

-- General configurations
c.font = wez.font("EnvyCodeR Nerd Font Mono", { weight = "Medium" })
c.font_rules = {
  {
    italic = true,
    intensity = "Half",
    font = wez.font("EnvyCodeR Nerd Font Mono", { weight = "Medium", italic = true }),
  },
}
c.font_size = 12
c.default_prog = utils.is_windows and
    { "cmd.exe", '/k', "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat" } or
    "zsh"
c.adjust_window_size_when_changing_font_size = false
c.audible_bell = "Disabled"
c.scrollback_lines = 3000
c.default_workspace = "main"
c.status_update_interval = 2000

local launch_menu = {}

if wez.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })

  -- Find installed visual studio version(s) and add their compilation
  -- environment command prompts to the menu
  table.insert(launch_menu, {
    label = 'x64 Native Tools VS 2022',
    args = {
      'cmd.exe',
      '/k',
      "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat",
    },
  })
end

c.launch_menu = launch_menu

-- appearance
appearance.apply_to_config(c)

-- keys
mappings.apply_to_config(c)

-- bar
bar.apply_to_config(c)

return c
