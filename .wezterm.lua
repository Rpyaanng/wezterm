local wezterm = require "wezterm"
local utils = require "lua.utils"
local act = wezterm.action

local appearance = require "lua.appearance"
local bar = wezterm.plugin.require "https://github.com/adriankarlen/bar.wezterm"
local mappings = require "lua.mappings"
local smart_splits = wezterm.plugin.require 'https://github.com/mrjones2014/smart-splits.nvim'
local sessionizer = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer.wezterm"

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- General configurations
config.default_prog = utils.is_windows and
    { "pwsh", "-NoLogo" } or
    "zsh"
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.scrollback_lines = 3000
config.default_workspace = "main"
config.status_update_interval = 2000
config.window_close_confirmation = 'NeverPrompt'

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
  command_options = {
    max_depth = 4,
  },
  paths = {
    "R:/",
    "~/projects",                        -- linux
    "C:/Users/RyanP/.config",            --windows
    "C:/Users/RyanP/Appdata/local/nvim", --windows
  }
}

local function isViProcess(pane)
  -- get_foreground_process_name On Linux, macOS and Windows,
  -- the process can be queried to determine this path. Other operating systems
  -- (notably, FreeBSD and other unix systems) are not currently supported
  return pane:get_foreground_process_name():find('n?vim') ~= nil or pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
  if isViProcess(pane) then
    window:perform_action(
    -- This should match the keybinds you set in Neovim.
      act.SendKey({ key = vim_direction, mods = 'ALT' }),
      pane
    )
  else
    window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
  end
end

wezterm.on('ActivatePaneDirection-right', function(window, pane)
  wezterm.log_info("Hello")
  conditionalActivatePane(window, pane, 'Right', 'l')
end)
wezterm.on('ActivatePaneDirection-left', function(window, pane)
  conditionalActivatePane(window, pane, 'Left', 'h')
end)
wezterm.on('ActivatePaneDirection-up', function(window, pane)
  conditionalActivatePane(window, pane, 'Up', 'k')
end)
wezterm.on('ActivatePaneDirection-down', function(window, pane)
  conditionalActivatePane(window, pane, 'Down', 'j')
end)

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
