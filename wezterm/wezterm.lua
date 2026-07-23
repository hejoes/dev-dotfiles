local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- coolnight colorscheme
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 12

config.enable_tab_bar = false

-- Make cs always launch Claude Code with --dangerously-skip-permissions.
-- cs runs `exec $CLAUDE_CODE_BIN --name ...`, so extra args here pass straight
-- through. Set at the terminal level so it syncs via dotfiles to every machine.
config.set_environment_variables = {
	CLAUDE_CODE_BIN = "claude --dangerously-skip-permissions",
}

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 20

-- Reliable copy/paste on macOS
config.keys = {
	-- Cmd+C: copy selection to clipboard
	{ key = "c", mods = "SUPER", action = wezterm.action.CopyTo("Clipboard") },
	-- Cmd+V: paste from clipboard
	{ key = "v", mods = "SUPER", action = wezterm.action.PasteFrom("Clipboard") },
}

return config
