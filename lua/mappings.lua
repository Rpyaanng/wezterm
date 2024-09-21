local wezterm = require "wezterm"
local act = wezterm.action
local callback = wezterm.action_callback
local os = require "os"

local mod = {
  c = "CTRL",
  s = "SHIFT",
  a = "ALT",
  l = "LEADER",
}
local sessionizer = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer.wezterm"

local keybind = function(mods, key, action)
  return { mods = table.concat(mods, "|"), key = key, action = action }
end

local M = {}

local leader = { mods = mod.c, key = "a", timeout_miliseconds = 1000 }

local keys = function()
  local keys = {

    -- CTRL-A, CTRL-A sends CTRL-A
    keybind({ mod.l, mod.c }, "a", act.SendString "\x01"),

    {
      key = 'r',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'resize_pane',
        timeout_milliseconds = 1000,
        one_shot = false,
      },
    },

    -- pane and tabs
    keybind({ mod.l }, "-", act.SplitVertical { domain = "CurrentPaneDomain" }),
    keybind({ mod.l }, "\\", act.SplitHorizontal { domain = "CurrentPaneDomain" }),
    keybind({ mod.l }, "m", act.TogglePaneZoomState),
    keybind({ mod.l }, "c", act.SpawnTab "CurrentPaneDomain"),
    keybind({ mod.l }, "h", act.ActivatePaneDirection "Left"),
    keybind({ mod.l }, "j", act.ActivatePaneDirection "Down"),
    keybind({ mod.c, mod.s }, "w", act.CloseCurrentPane { confirm = false }),
    keybind({ mod.l }, "k", act.ActivatePaneDirection "Up"),
    keybind({ mod.l }, "l", act.ActivatePaneDirection "Right"),
    keybind({ mod.l }, "m", callback(function(win, pane)
      local InActive = nil;
      for _, item in ipairs(win:active_tab():panes_with_info()) do
        if not item.is_active then
          item.pane:paste("fd shell | cmd /k \n")
          return
        end
      end
      local action = wezterm.action {
        SplitPane = {
          direction = 'Right',
          size = { Percent = 30 },
          command = {
            args = {
              'cmd',
              '/k',
              'fd shell | cmd /k',
            },
          },
        },
      };
      win:perform_action(action, pane);
    end)),
    keybind({ mod.l }, "x", act.CloseCurrentPane { confirm = true }),

    keybind({ mod.l, mod.s }, "&", act.CloseCurrentTab { confirm = true }),
    keybind(
      { mod.l },
      "e",
      act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Renaming Tab Title...:" },
        },
        action = callback(function(win, _, line)
          if line == "" then
            return
          end
          win:active_tab():set_title(line)
        end),
      }
    ),

    -- workspaces
    keybind({ mod.l }, "w", act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" }),

    -- copy and paste
    keybind({ mod.c }, "c", act.CopyTo "Clipboard"),
    keybind({ mod.c }, "v", act.PasteFrom "Clipboard"),


    -- sessionizer
    keybind({ mod.l }, "f", sessionizer.show),

    -- launch spotify-tui as a small pane in the bottom
    keybind(
      { mod.l },
      "s",
      act.SplitPane {
        direction = "Down",
        command = { args = { "spt" } },
        size = { Cells = 20 },
      }
    ),

    -- update all plugins
    keybind(
      { mod.l },
      "u",
      callback(function(win)
        wezterm.plugin.update_all()
        win:toast_notification("wezterm", "plugins updated!", nil, 4000)
      end)
    ),
  }


  -- tab navigation
  for i = 1, 9 do
    table.insert(keys, keybind({ mod.l }, tostring(i), act.ActivateTab(i - 1)))
  end
  return keys
end

local keyTables = function()
  return {
    resize_pane = {
      { key = "h",      action = act.AdjustPaneSize { "Left", 5 } },
      { key = "j",      action = act.AdjustPaneSize { "Down", 5 } },
      { key = "k",      action = act.AdjustPaneSize { "Up", 5 } },
      { key = "l",      action = act.AdjustPaneSize { "Right", 5 } },
      -- Cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    }
  }
end

M.apply_to_config = function(c)
  c.treat_left_ctrlalt_as_altgr = true
  c.leader = leader
  c.keys = keys()
  c.key_tables = keyTables()
end

return M
