# Zsh: autocomplete & history

## 1. Installation

### Setup zsh-autosuggestions

This plugin provides auto completion functionality as typing out commands

```

brew install zsh-autosuggestions

echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

source ~/.zshrc
```

### Setup zsh-syntax-highlighting

This will provide syntax highlighting as typing out commands.

```
brew install zsh-syntax-highlighting
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
source ~/.zshrc
```

### Setup fzf

Fuzzy-finder, used here for fuzzy history search (`Ctrl+R`), fuzzy file find
(`Ctrl+T`), and completion.

```
brew install fzf
echo "source <(fzf --zsh)" >> ~/.zshrc
source ~/.zshrc
```

### Setup zoxide

A smarter `cd` that jumps to frecently-used directories by partial name
instead of a full path.

NB! Keep in mind that you first use regular  `cd` command in order to be able to use `z` since zoxide needs training first.

```
brew install zoxide
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
source ~/.zshrc
```

Optional - Map alias `cd` itself to zoxide's `z`

```
echo 'alias cd="z"' >> ~/.zshrc
source ~/.zshrc
```

### Setup eza

A modern replacement for `ls` with icons and git-aware coloring. No shell
init hook needed, just install it and alias `ls` to it:

```
brew install eza
echo 'alias ls="eza -la --icons=always --color=always"' >> ~/.zshrc
source ~/.zshrc
```

See section 6 below for the fuller set of `ls`/`lf`/`ld`/`lh` aliases used
in this repo's actual `.zshrc`.


## 3. Autosuggestions & syntax highlighting

```zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

**Verify it worked**:
- Type `ls` (a real command) and it should turn green as you finish typing
  it.
- Type `lsx` (not a real command) and it should turn red.
- Type `git st` (assuming you've run a `git` command before) and you should
  see the rest of a previous matching command (e.g. `atus`) appear greyed
  out after your cursor. Press `→` to accept it, or keep typing to ignore
  it.

## 4. History

```zsh
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history        # share history live across all open terminals
setopt hist_expire_dups_first
setopt hist_ignore_dups     # don't save a command if it's a duplicate of the previous one
setopt hist_verify          # let you edit a recalled history command before running it

# Up/Down arrows search history matching what you've already typed,
# instead of just scrolling through everything
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
```

**Verify it worked**: run a distinctive command like `echo hello-world-test`.
Then type `echo` and press the `↑` (up arrow) key. It should jump straight
to `echo hello-world-test`, not just the most recent command in general.
Open a second terminal tab and run a command in it, it should show up when
you press `↑` in the first tab too (that's `share_history`).

## 5. Fuzzy history search (fzf)

```zsh
source <(fzf --zsh)

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#d0d0d0,fg+:#d0d0d0,bg:#121212,bg+:#3a3c10
  --color=hl:#07f4d8,hl+:#06f5b5,info:#afaf87,marker:#b9f49c
  --color=prompt:#078060,spinner:#af5fff,pointer:#0cf8b9,header:#07f4d8
  --color=border:#262626,preview-fg:#ffffff,label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'

# Fuzzy-search your whole shell history and run whatever you select
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}
```

`fzf --zsh` also wires up `Ctrl+R` (fuzzy history search) and `Ctrl+T`
(fuzzy file finder) automatically.

**Verify it worked**:
- Press `Ctrl+R`, start typing part of any command you've run before. A
  fuzzy-matched, scrollable list should pop up. Press `Enter` to run the
  selected one, or `Esc` to cancel.
- Press `Ctrl+T` in any directory. A fuzzy file picker should pop up, select
  a file and press `Enter`, its path gets inserted at your cursor.
- Type `fh` and press `Enter`. Same idea as `Ctrl+R`, but as a standalone
  command instead of a keybinding.

## 6. Optional: zoxide (smarter `cd`) and eza (nicer `ls`)

```zsh
# zoxide - only in interactive shells, and only alias `cd` if you actually want this
if [[ $- == *i* ]]; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

alias ls="eza -la --sort=modified --reverse --icons=always --color=always"
alias lf="eza -lf --color=always --icons=always | grep -v /"
alias ld="eza -lD --color=always --icons=always"
alias lh="eza -dl .* --group-directories-first --color=always --icons=always"
```

`aliasing cd="z"` means plain `cd /some/path` still works exactly as
before, but `cd partial-name` (no path) will jump to the best frecency match
zoxide has learned, the more you `cd` somewhere, the higher it ranks.

**Verify it worked**:
- Run `ls` in any directory with a few files. You should see file-type
  icons next to each name, and directories sorted with the most recently
  modified first.
- `cd` into a couple of different real directories first (e.g.
  `cd ~/.config` then `cd ~/Downloads`), so zoxide has something to learn.
  Then from anywhere, run `cd config` (no slash, no full path). It should
  jump you straight to `~/.config`.

## Putting it all together: the order that works

```
1. fpath + compinit                         (register completion system)
2. any tool completions (flux, gh, etc.)    (must come after compinit)
3. zsh-autosuggestions
4. history options + arrow-key bindings
5. fzf integration
6. zoxide / eza (optional)
7. Starship prompt init (see ../starship/README.md)
8. zsh-syntax-highlighting                  (must always be LAST)
```

You don't have to follow this exact layout inside `.zshrc`, plenty of
unrelated `export`/alias lines can sit anywhere, but relative to each
other, these building blocks need to stay in this order or you'll see
exactly the kind of startup errors this README exists to help you avoid.

## Learn more

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [fzf](https://github.com/junegunn/fzf) / [fzf docs site](https://junegunn.github.io/fzf/)
- [zoxide](https://github.com/ajeetdsouza/zoxide) / [zoxide.org](https://zoxide.org/)
- [eza](https://github.com/eza-community/eza): community-maintained continuation of the now-unmaintained `exa`
