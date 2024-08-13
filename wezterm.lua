-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.color_scheme = 'Solarized (light) (terminal.sexy)'
config.font = wezterm.font_with_fallback {
	'Fira Code Nerd',
	'Fira Code',
}

config.bold_font = auto
config.italic_font = auto
config.bold_italic_font = auto
config.disable_ligatures = never
-- url_prefixes = http https file ftp
config.open_url_with = open
config.strip_trailing_spaces=smart
-- config.term=xterm-256color

config.show_update_window = false
config.check_for_updates = false

config.adjust_window_size_when_changing_font_size = false

local act = wezterm.action

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local super_key
local ctrl_key
local meta_key

if is_darwin then 
	config.font_size = 12

	-- left command
	super_key = "SUPER"

	-- ctrl
	ctrl_key = "CTRL"

	-- Option key
	meta_key = "META"
else
	config.font_size = 16

	super_key = "CTRL"

	-- left command (logo key)
	ctrl_key = "SUPER"

	meta_key = "META"
end


config.keys = {
	-- copy pasta
	{
		key = 'c',
		mods = super_key,
		action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection'
	},
	{
		key = 'v',
		mods = super_key,
		action = act.PasteFrom 'Clipboard'
	},
	-- Panes
	{
		key = 'f',
		mods = meta_key,
		action = wezterm.action.TogglePaneZoomState
	},
	{
		key = '_',
		mods = super_key,
		action = wezterm.action.SplitVertical
	},
	{
		key = '|',
		mods = super_key,
		action = wezterm.action.SplitHorizontal
	},
	{
		key = 'h',
		mods = super_key,
		action = wezterm.action.ActivatePaneDirection 'Left'
	},
	{
		key = 'l',
		mods = super_key,
		action = wezterm.action.ActivatePaneDirection 'Right'
	},
	{
		key = 'j',
		mods = super_key,
		action = wezterm.action.ActivatePaneDirection 'Down'
	},
	{
		key = 'k',
		mods = super_key,
		action = wezterm.action.ActivatePaneDirection 'Up'
	},
	
	-- TODO: windows
	{
		key = 'n',
		mods = super_key,
		action = wezterm.action.SpawnWindow
	},

	-- tabs
	{
		key = 't',
		mods = super_key,
		action = act.SpawnTab 'CurrentPaneDomain',
	},
    {
		key = 'LeftArrow',
		mods = super_key,
		action = act.ActivateTabRelative(-1)
	},
    {
		key = 'RightArrow',
		mods = super_key,
		action = act.ActivateTabRelative(1)
	},

	-- control keys
	{
		key = 'l',
		mods = ctrl_key,
		action = act.SendKey {
			key = 'l',
			mods = 'CTRL',
		},
	},
	{
		key = 'd',
		mods = ctrl_key,
		action = act.SendKey {
			key = 'd',
			mods = 'CTRL',
		},
	},
	{
		key = 'c',
		mods = ctrl_key,
		action = act.SendKey {
			key = 'c',
			mods = 'CTRL',
		},
	},
	{
		key = 'a',
		mods = ctrl_key,
		action = act.SendKey {
			key = 'a',
			mods = 'CTRL',
		},
	},
	{
		key = 'e',
		mods = ctrl_key,
		action = act.SendKey {
			key = 'e',
			mods = 'CTRL',
		},
	},
}



-- and finally, return the configuration to wezterm
return config


