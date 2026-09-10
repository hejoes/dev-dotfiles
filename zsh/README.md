# Zsh: autocomplete & history

This covers the shell-level pieces that make the terminal experience feel
complete: tab-completion (including custom completions like Herdr's),
inline autosuggestions, syntax highlighting, fuzzy history search, and
shared/persistent shell history. None of this lives in a single config file —
it's a handful of blocks you add to `~/.zshrc`, in a specific order that
matters (explained below).

## 1. Install the pieces

```bash
brew install zsh-autosuggestions zsh-syntax-highlighting fzf zoxide eza
```

- **zsh-autosuggestions**: greys out a suggested command as you type, based
  on history — press `→` (right arrow) to accept it.
- **zsh-syntax-highlighting**: colors commands green/red as you type,
  depending on whether they're valid.
- **fzf**: fuzzy-finder, used here for fuzzy history search and completion.
- **zoxide**: a smarter `cd` that jumps to frecently-used directories by
  partial name.
- **eza**: a modern replacement for `ls` with icons and git-aware coloring.

## 2. Completions (`fpath` + `compinit`)

This repo's `zsh/completions/` directory holds custom completion scripts
(e.g. `_herdr`). Point zsh's `fpath` at it, **then** initialize the
completion system:

```zsh
fpath=("$HOME/.config/zsh/completions" $fpath)
autoload -U compinit; compinit
```

**Order matters here, and it trips people up:** anything that registers a
completion — either your own custom completions above, *or* any tool's
generated completion script sourced later (`. <(sometool completion zsh)`,
`eval "$(othertool init zsh)"`, etc.) — must come **after** `compinit` has
run. `compinit` is what defines `compdef`, the function completion scripts
register themselves with. Source one before `compinit` runs and you'll get
startup errors like `command not found: compdef` or garbled output on every
new terminal. If you ever add a new CLI tool's shell completion, add it
*after* the `compinit` line above, not before.

## 3. Autosuggestions & syntax highlighting

```zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

**`zsh-syntax-highlighting` must be sourced last** — after this, after
`compinit`, after everything else in your `.zshrc` that touches
`widgets`/`ZLE`. This is a documented requirement of the plugin itself, not
a preference: sourcing anything after it can silently break the
highlighting.

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
zoxide has learned — the more you `cd` somewhere, the higher it ranks.

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

You don't have to follow this exact layout inside `.zshrc` — plenty of
unrelated `export`/alias lines can sit anywhere — but relative to each
other, these building blocks need to stay in this order or you'll see
exactly the kind of startup errors this README exists to help you avoid.
