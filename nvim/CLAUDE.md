# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Overview

This is a Neovim configuration built on top of
[LazyVim](http://www.lazyvim.org/) that combines ideas from Kickstarter. It's
designed for infrastructure-as-code development (Terraform, Kubernetes, Helm,
Ansible) with AI-powered code assistance through GitHub Copilot.

## Architecture

### Plugin Structure

Plugins are organized into four main categories under `lua/plugins/`:

- **code/**: Language support and code manipulation
  - `copilot.lua`: GitHub Copilot with blink.cmp integration
  - `treesitter.lua`: Syntax highlighting and parsing
  - `languages/`: Language-specific configurations (Terraform, Markdown)

- **editor/**: Core editing functionality
  - `telescope.lua`: Fuzzy finding with custom Helm values picker
  - `blink-completion.lua`: Completion engine with Copilot integration
  - `yazi.lua`: File manager integration

- **ui/**: Visual elements (status lines, notifications, colorscheme)

- **git/**: Git integration (gitsigns, Lazygit, flog, git-blame)

### Configuration Files

- `init.lua`: Bootstraps lazy.nvim by requiring `config.lazy`
- `lua/config/lazy.lua`: Sets up plugin spec with LazyVim extras and custom
  plugin imports
- `lua/config/keymaps.lua`: Custom keybindings (see Usage section)
- `lua/config/options.lua`: Editor options (wrapping, folding, paste
  performance)
- `lua/config/autocmds.lua`: Auto-commands for CWD updates and performance
  optimizations

### Key Technical Details

**Plugin Management**: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) with
automatic updates enabled (`checker = { enabled = true }`).

**Lazy Loading**: Custom plugins are NOT lazy-loaded by default
(`defaults.lazy = false`). LazyVim plugins use their own lazy-loading
strategies.

**LSP Configuration**: YAML LSP is configured in `lua/config/lazy.lua` with
schemas for Kubernetes, GitHub workflows, Ansible, and Helm charts.

**AI Integration & Automation**:

- Copilot integrates with blink.cmp and hides suggestions when the completion
  menu is open
- Tab key accepts Copilot suggestions, works across all file types including
  markdown
- Copilot suggestions appear inline and integrate seamlessly with the completion
  system
- Auto-save enabled on BufLeave, FocusLost, InsertLeave, and TextChanged events

**Performance Optimizations**:

- Paste operations are optimized with timeout settings and autocmds in
  `autocmds.lua`
- Treesitter folding is enabled with `foldlevel=1`

**Completion System**: blink.cmp with sources ordered by priority:

1. Copilot (score_offset: 100)
2. LSP, path, snippets, buffer

Command-line completion is enabled via blink.cmp for enhanced `:` command
experience.

**Disabled Plugins:**

- `tmux.nvim` - Removed entirely (use external tmux instead)

## Common Development Commands

### Plugin Management

```vim
:Lazy                  " Open Lazy plugin manager
:Lazy sync             " Update plugins
:Lazy clean            " Remove unused plugins
```

### LSP & Treesitter

```vim
:Mason                 " Open Mason LSP/formatter installer
:TSUpdate              " Update Treesitter parsers
:TSInstallInfo         " Show installed parsers
```

### Helm Values Workflow

Use `<leader>hv` to interactively browse Helm chart values:

1. Select repository from local helm repos
2. Choose chart (shows version count)
3. Select specific version
4. Opens values.yaml in vertical split at `/tmp/helm_values_*.yaml`

The implementation uses `helm repo list`, `helm search repo --versions`, and
`helm show values`.

## Key Bindings Reference

### Window Navigation

- `sh`: Split window horizontally (stacked)
- `sv`: Split window vertically (side-by-side)
- `ml/mr/mj/mk`: Navigate between Neovim windows (left/right/down/up)
- `M-{Up,Down,Left,Right}`: Resize windows with arrow keys

### File Management

- `ff`: Fuzzy find files
- `fg`/`fG`: Grep through files
- `cg`: Grep in current buffer
- `cG`: Grep in entire project (from root)
- `yy`: Open Yazi file manager
- `,`: Navigate between buffers
- `e`/`E`: Open NeoTree

### Code Navigation

- `H`: LSP hover (remapped from `K`)
- `J`: Jump down 20 lines
- `K`: Jump up 20 lines
- `ct`: Show tags in current buffer

### Git

- `<leader>gg`: Open Lazygit (borderless)
- `<leader>gdf`: File commit history (Diffview)
- `<leader>gdr`: Repo commit history
- `<leader>gdo`: Diff compare HEAD & merge conflicts
- `<leader>gda`: Advanced Git search

### Markdown

- `<leader>mp`: Toggle Markdown preview

### Clipboard Behavior

By default, `d` and `c` do NOT copy (use black hole register):

- `d`/`c`: Delete/change without copying
- `<leader>d`/`<leader>c`: Delete/change and copy to clipboard

## Language Support

Configured for: Bash, YAML, Python, Docker, JSON, Lua, Helm, TOML, Markdown,
Ansible, Terraform

Treesitter parsers auto-install on first use. HCL parser is used for Terraform
files (`terraform` and `terraform-vars` filetypes).

## Working Directory Behavior

The `BufEnter` autocmd in `autocmds.lua` automatically updates the local working
directory (`lcd`) to match the directory of the file being edited. This ensures
file operations (like telescope searches) work relative to the current file's
location when switching between files via Yazi or terminal.

## Supported Languages & Tools

Ensure these are installed in `$PATH`:

- npm
- fzf, zoxide
- Terraform
- Yazi
- Nerd Font (e.g., `font-meslo-lg-nerd-font`)
- shellcheck (for bash linting)
- Lazygit
- gh (GitHub CLI)

## LazyVim Extras

The following LazyVim extras are imported (see `lua/config/lazy.lua`):

- `editor.aerial`: Code outline
- `lang.docker`, `lang.json`, `lang.markdown`, `lang.terraform`, `lang.python`,
  `lang.yaml`, `lang.git`, `lang.helm`, `lang.toml`, `lang.ansible`
- `linting.eslint`
- `vscode`: VSCode integration support

## Troubleshooting

### Neovim Crashes or Exits When Opening Files

**Symptom:** Neovim exits to terminal when opening files via Telescope, NeoTree,
or rapidly switching buffers. Logs show "TUI already stopped (race?)" errors.

**Root Cause:** Zombie nvim processes running in the background from previous
sessions interfere with new nvim instances, causing TUI race conditions.

**Solution:**

```bash
# Check for zombie nvim processes
ps aux | grep nvim | grep -v grep

# Kill all nvim processes
killall nvim

# If that doesn't work, force kill by PID
kill -9 <PID>

# Clean temporary files
rm -rf /tmp/nvim.* ~/.local/state/nvim/shada/*

# Restart nvim
nvim
```

**Prevention:** Always properly exit nvim with `:qa` or `:q` instead of
force-closing terminal windows.

## Usage

- Do not create any additional `.md` files when outputting the results!
