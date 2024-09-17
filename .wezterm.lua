local wezterm = require "wezterm"
local utils = require "lua.utils"

local appearance = require "lua.appearance"
local bar = wezterm.plugin.require "https://github.com/adriankarlen/bar.wezterm"
local mappings = require "lua.mappings"

local sessionizer = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer.wezterm"

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- General configurations
config.font = wezterm.font("EnvyCodeR Nerd Font Mono", { weight = "Medium" })
config.font_rules = {
  {
    italic = true,
    intensity = "Half",
    font = wezterm.font("EnvyCodeR Nerd Font Mono", { weight = "Medium", italic = true }),
  },
}
config.font_size = 12
config.default_prog = utils.is_windows and
    { "cmd.exe", '/k', "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat" } or
    "zsh"
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.scrollback_lines = 3000
config.default_workspace = "main"
config.status_update_interval = 2000

local launch_menu = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
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

-- you can also list multiple paths
sessionizer.config = {
  paths = {
    "R:/",
    "~/projects",             -- linux
    "C:/Users/RyanP/.config", --windows
  }
}

config.launch_menu = launch_menu

-- appearance
appearance.apply_to_config(config)

-- keys
mappings.apply_to_config(config)

-- bar
bar.apply_to_config(config)

-- sessionizer
sessionizer.apply_to_config(config)

return config
