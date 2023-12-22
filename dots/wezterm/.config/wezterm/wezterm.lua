local wezterm = require("wezterm")
local home = wezterm.home_dir
-- Watch the colorscheme and reload in case of change
-- wezterm.add_to_config_reload_watch_list(home .. "/.cache/wal/wezterm-base16-wal.toml")

local config = {}

config.hide_tab_bar_if_only_one_tab = true
config.default_prog = { "fish", "-l" }
config.window_background_opacity = 0.95
config.enable_wayland = true
config.default_gui_startup_args = { "start", "--always-new-process" }
-- config.color_scheme_dirs = { home .. "/.cache/wal" }
-- config.color_scheme = "wezterm-base16-wal"
config.font = wezterm.font_with_fallback({
	-- { family = "Iosevka", stretch = "Expanded", weight = "Regular" },
	"JetBrains Mono",
	"Symbols Nerd Font",
})
config.font_size = 13.0
local gpus = wezterm.gui.enumerate_gpus()
config.webgpu_preferred_adapter = gpus[2]
config.front_end = "WebGpu"

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "\\",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	-- CTRL-SHIFT-l activates the debug overlay
	{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}

return config
