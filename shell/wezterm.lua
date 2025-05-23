local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- Detect the OS
local is_windows = wezterm.target_triple:find("windows") ~= nil

-- Launch WSL only in windows
if is_windows then
	config.default_domain = "WSL:Ubuntu"
end

-- Appearance Catppuccin, Dracula, Gruvbox, Tokyo Night, and One Dark are popular choices.
config.color_scheme = "Tokyo Night"
config.font = wezterm.font_with_fallback({ "JetBrains Mono", "Fira Code", "Noto Color Emoji" })
config.font_size = 13.0
-- Command palette colors (Tokyo Night style)
config.command_palette_bg_color = "#1a1b26" -- Tokyo Night background
config.command_palette_fg_color = "#c0caf5" -- Tokyo Night foreground

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

-- Window
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.initial_cols = 120
config.initial_rows = 30
config.window_padding = { left = 8, right = 8, top = 8, bottom = 0 }
config.scrollback_lines = 10000

-- Keybinding
config.keys = {
	{
		key = "Enter",
		mods = "CMD",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "p",
		mods = "CTRL|ALT",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "powershell.exe" },
			domain = { DomainName = "local" },
		}),
	},
}

return config
