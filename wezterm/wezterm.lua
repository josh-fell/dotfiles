local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

config.default_cwd = wezterm.home_dir
config.window_decorations = "RESIZE"
config.default_cursor_style = "SteadyBlock"
config.color_scheme = "Dracula (Official)"
config.font = wezterm.font("FiraCode Nerd Font")
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_padding = { top = 5 }
config.adjust_window_size_when_changing_font_size = false
config.inactive_pane_hsb = { brightness = 0.3 }

config.keys = {
	-- New tabs open to $HOME directory.
	{
		key = "t",
		mods = "CMD",
		action = wezterm.action({
			SpawnCommandInNewTab = { cwd = wezterm.home_dir },
		}),
	},
	-- New windows open to $HOME directory, pinned to left side of screen.
	{
		key = "n",
		mods = "CMD",
		action = act.SpawnCommandInNewWindow({ cwd = wezterm.home_dir }),
	},
	{
		key = "_",
		mods = "CMD|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "CMD|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Close only the current pane.
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{ key = "h", mods = "CMD", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CMD", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CMD", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CMD", action = act.ActivatePaneDirection("Right") },

	-- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app
   -- behavior
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({ key = "b", mods = "ALT" }),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
}

-- Initial startup creates a window pinned to the right side of screen.
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
