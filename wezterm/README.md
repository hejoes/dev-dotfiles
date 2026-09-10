# WezTerm

A fast, GPU-accelerated terminal emulator, configured here with a dark
"coolnight" theme, a Nerd Font (for icons in Starship/eza/etc.), and reliable
Cmd+C/Cmd+V clipboard handling on macOS.

## Install

```bash
brew install --cask wezterm
brew install --cask font-meslo-lg-nerd-font
```

The Nerd Font is required — Starship's prompt symbols, `eza`'s file icons, and
this config's own glyphs will render as boxes/question marks without it.

## Get the config

WezTerm looks for its config at `~/.config/wezterm/wezterm.lua` by default (no
extra steps needed if you clone this whole repo to `~/.config`). If you only
want the WezTerm piece, copy just this file:

```bash
mkdir -p ~/.config/wezterm
cp wezterm.lua ~/.config/wezterm/wezterm.lua
```

Open WezTerm (or press `Cmd+Shift+R` inside it) to reload the config.

## What's in `wezterm.lua`

- **Theme**: a custom dark blue/purple palette ("coolnight"), background
  opacity 0.8 with macOS window blur, resizable borderless-style window
  (`RESIZE` decorations only).
- **Font**: `MesloLGS Nerd Font Mono` at size 12.
- **Tab bar**: disabled (`enable_tab_bar = false`) — this setup relies on
  Herdr (`../herdr/config.toml`) for workspace/tab management instead of
  WezTerm's own tab bar.
- **Keybindings**: `Cmd+C` / `Cmd+V` are remapped to explicit
  copy-to-clipboard / paste-from-clipboard actions. This exists because
  default terminal copy/paste can be unreliable inside tmux-like tools;
  binding it explicitly at the WezTerm level guarantees it always works.
- **`CLAUDE_CODE_BIN` environment variable**: sets a default flag
  (`--dangerously-skip-permissions`) for Claude Code when launched through
  certain wrapper scripts. This only matters if you use a tool that reads
  `$CLAUDE_CODE_BIN` to launch Claude Code (e.g. a custom session-manager
  script) — safe to ignore or remove if you don't.

## Customizing

Colors live in `config.colors = { ... }` at the top of the file — swap any of
the ANSI/bright color hex values to change the palette without touching
anything else. Font and size are single-line changes (`config.font`,
`config.font_size`).
