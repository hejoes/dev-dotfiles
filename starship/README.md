# Starship

A fast, customizable prompt shown here with a segmented "powerline" style
(OS icon → username → directory → git branch/status → language versions →
Docker context → time), using the Catppuccin Mocha color palette.

<img src="https://i.imgur.com/49Q50Od.png" alt="500" width="700">

## Install

```bash
brew install starship
brew install --cask font-meslo-lg-nerd-font   # if not already installed
```

The Nerd Font is required for the prompt's icons (OS symbol, git branch icon,
language logos, etc.) to render instead of showing as boxes/question marks.

## Get the config

```bash
mkdir -p ~/.config/starship
cp starship.toml ~/.config/starship/starship.toml
```

## Hook it into zsh

Add these two lines to `~/.zshrc`, near the end of the file (Starship
needs to run after your shell options and other prompt-related plugins are
already set up):

```zsh
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
```

Open a new terminal (or `source ~/.zshrc`) and the prompt should appear
immediately.

## Verify it worked

- **Basic prompt**: open a new terminal. You should see a row of colored
  segments (OS icon, username, current directory) ending in an arrow, with
  your cursor on the line below it, not a plain `%` or `$`.
- **Git segment**: `cd` into any git repo, for example this one
  (`cd ~/.config`). A green segment should appear showing the branch name
  (e.g. `master`), and if you have uncommitted changes, status symbols next
  to it (`!` modified, `?` untracked, etc.). Run `touch test.txt` in that
  repo and the `?` symbol should appear immediately, then `rm test.txt` to
  clean up.
- **Language segment**: `cd` into any Node.js project (a directory with a
  `package.json`). A segment with the Node.js logo and version number should
  appear. `cd` back out and it disappears, this is expected, these segments
  are contextual.
- **Icons rendering correctly**: if any of the above shows a box (`▯`) or
  question mark instead of an icon, the Nerd Font isn't installed or isn't
  set in WezTerm's `config.font` (see `../wezterm/README.md`).

## Notes

- **Make sure nothing else sets your prompt.** If you have `PS1` set
  elsewhere in `.zshrc`, or another prompt framework (oh-my-zsh themes,
  powerlevel10k, etc.) initialized, it'll fight with Starship for control of
  the prompt. Starship should be the only thing managing `PS1`.
- **`command_timeout`** (top of `starship.toml`) is raised to `1500` (ms).
  Starship's default (500ms) can be too tight for git status in large
  repositories or a big multi-tool dotfiles tree like this one. If you see
  a `command timed out` warning on startup, raise this further rather than
  treating it as broken.
- The `[os.symbols]` section overrides the macOS icon, this is cosmetic and
  safe to delete or change.
- Language segments (`[python]`, `[nodejs]`, `[rust]`, etc.) only appear when
  you `cd` into a directory Starship recognizes as that language's project
  (e.g. a `package.json` for Node). Nothing to configure, they just show up
  contextually.

## Learn more

- [starship.rs](https://starship.rs/)
- [Beautiful CLI Prompt With Starship](https://kittygiraudel.com/2026/03/13/beautiful-cli-prompt-with-starship/)
