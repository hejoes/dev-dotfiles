# WezTerm

A fast terminal emulator, configured with a dark
"coolnight" theme, a Nerd Font (for icons in Starship/eza/etc.)

## Install

```bash
brew install --cask wezterm
brew install --cask font-meslo-lg-nerd-font
```


## Get my wezterm theme to your's

WezTerm looks for its config at `~/.config/wezterm/wezterm.lua` by default (no
extra steps needed if you clone this whole repo to `~/.config`). If you only
want the WezTerm piece, copy just this file:

```bash
mkdir -p ~/.config/wezterm
cp wezterm.lua ~/.config/wezterm/wezterm.lua
```

Open WezTerm (or press `Cmd+Shift+R` inside it) to reload the config.

## Verify it worked

- **Theme and font**: the window should be dark blue/purple with a slightly
  transparent, blurred background, no tab bar, and text rendered in
  MesloLGS Nerd Font Mono. If you see boxes or missing glyphs anywhere
  (Starship's prompt icons are the easiest place to spot this), the font
  didn't install or WezTerm isn't picking it up, restart WezTerm fully and
  check `config.font` in `wezterm.lua`.
- **Copy/paste**: select some text in the terminal, press `Cmd+C`, click into
  a text field in another app (or a new line in the same terminal), press
  `Cmd+V`. The selected text should paste. This confirms the `config.keys`
  clipboard bindings in `wezterm.lua` are active.

## Learn more

- [wezterm.org](https://wezterm.org/)
