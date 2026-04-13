

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

config.font = wezterm.font 'Fira Code'
config.font_size = 13
config.color_scheme = 'Catppuccin Mocha'

config.window_background_opacity = 0.9
config.max_fps = 240

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

local function move_pane(key, direction)
return {
    key = key,
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection(direction),
}
end

local function resize_pane(key, direction)
return {
    key = key,
    action = wezterm.action.AdjustPaneSize { direction, 3 }
}
end

config.keys = {
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 't',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'w',
        mods = 'LEADER',
        action = wezterm.action.CloseCurrentPane { confirm = false },
    },
    {
        key = '-',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = '=',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'a',
        -- When we're in leader mode _and_ CTRL + A is pressed...
        mods = 'LEADER|CTRL',
        -- Actually send CTRL + A key to the terminal
        action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
    },
    move_pane('j', 'Down'),
    move_pane('k', 'Up'),
    move_pane('h', 'Left'),
    move_pane('l', 'Right'),
    {
        -- When we push LEADER + R...
        key = 'r',
        mods = 'LEADER',
        -- Activate the `resize_panes` keytable
        action = wezterm.action.ActivateKeyTable {
            name = 'resize_panes',
            -- Ensures the keytable stays active after it handles its
            -- first keypress.
            one_shot = false,
            -- Deactivate the keytable after a timeout.
            timeout_milliseconds = 1000,
        }
    },
  {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(-1),
  },
}

config.key_tables = {
    resize_panes = {
        resize_pane('j', 'Down'),
        resize_pane('k', 'Up'),
        resize_pane('h', 'Left'),
        resize_pane('l', 'Right'),
    },
}

return config
