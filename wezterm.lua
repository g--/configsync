-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'AdventureTime'
config.font = wezterm.font 'FiraCode'
config.font_size = 16
config.show_update_window = false
config.check_for_updates = false

local act = wezterm.action

config.keys = {
	-- copy pasta
	{
		key = 'c',
		mods = 'CTRL',
		action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection'
	},
	{
		key = 'v',
		mods = 'CTRL',
		action = act.PasteFrom 'Clipboard'
	},
	-- TODO: sub-windows?
	-- TODO: windows
	{
		key = 'n',
		mods = 'CTRL',
		action = wezterm.action.SpawnWindow
	},

	-- tabs
	{
		key = 't',
		mods = 'CTRL',
		action = act.SpawnTab 'CurrentPaneDomain',
	},
    {
		key = 'LeftArrow',
		mods = 'CTRL',
		action = act.ActivateTabRelative(-1)
	},
    {
		key = 'RightArrow',
		mods = 'CTRL',
		action = act.ActivateTabRelative(1)
	},

	-- control keys
	{
		key = 'l',
		mods = 'SUPER',
		action = act.SendKey {
			key = 'l',
			mods = 'CTRL',
		},
	},
	{
		key = 'd',
		mods = 'SUPER',
		action = act.SendKey {
			key = 'd',
			mods = 'CTRL',
		},
	},
	{
		key = 'c',
		mods = 'SUPER',
		action = act.SendKey {
			key = 'c',
			mods = 'CTRL',
		},
	},
	{
		key = 'a',
		mods = 'SUPER',
		action = act.SendKey {
			key = 'a',
			mods = 'CTRL',
		},
	},
	{
		key = 'e',
		mods = 'SUPER',
		action = act.SendKey {
			key = 'e',
			mods = 'CTRL',
		},
	},
}

config.color_scheme = 'Solarized (light) (terminal.sexy)'


-- and finally, return the configuration to wezterm
return config


