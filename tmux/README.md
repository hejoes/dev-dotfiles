# Tmux - Terminal Multiplexer

## Features

- [TPM](TPM) package manager
- [Vim-tmux-navigator](Vim-tmux-navigator) - easy switching between nvim and
  tmux windows
- [Tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) - Collection of
  useful tmux options
- [Tmux-sessionx](https://github.com/omerxx/tmux-sessionx) - easy session
  management

## Usage

Some shortcuts that will get you around:

- I have bind `C-a` as **leader**, personal preference however. You can change
  keymaps under `tmux.conf`
- `M-{j,k,h,l}` - Resize open tmux panes
- `C-{j,k,h,l}` - Switch between tmux panes
- `M` - Minimize/maximize current pane
- `,` - Rename current window
- `s` - Open sessionx session manager
- `x` - Kill current pane (doesn't ask confirm)
- `c` - Create new window in current session
