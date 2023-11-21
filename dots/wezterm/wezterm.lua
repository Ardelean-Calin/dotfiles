local wezterm = require("wezterm")
local home = wezterm.home_dir
-- Watch the colorscheme and reload in case of change
wezterm.add_to_config_reload_watch_list(home .. "/.cache/wal/wezterm-base16-wal.toml")

local config = {}

config.hide_tab_bar_if_only_one_tab = true
config.default_prog = { "fish", "-l" }
config.window_background_opacity = 0.95
config.color_scheme_dirs = { home .. "/.cache/wal" }
config.color_scheme = "wezterm-base16-wal"
config.font = wezterm.font_with_fallback({
	"Iosevka Extended",
	"JetBrains Mono",
	"Font Awesome 6 Free Solid",
})
local gpus = wezterm.gui.enumerate_gpus()
config.webgpu_preferred_adapter = gpus[1]
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
}

return config
