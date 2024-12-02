<h2 align="center">
    <br>
  <a href="https://neovim.io">
    <img src="https://github.com/mstuttgart/nvim/assets/8174740/585d3de3-fb9e-43f8-bc43-068aa073b157" width="50%">
  </a>
</h2>

</p>

<p align="center">
  <a href="#About">About</a> |
  <a href="#Pre-requisites">Pre-requisites</a> |
  <a href="#Features">Features</a> |
  <a href="#Usage">Usage</a> |
</p>

## About

This nvim setup will hopefully save you some time and nerve cells if you plan on
migrating over. It uses 💤 [Lazyvim](http://www.lazyvim.org/) as it's base and
combines some ideas/configuration from
[kickstarter](https://github.com/nvim-lua/kickstart.nvim).

## Features

This setup covers over 60plugins. I have provided here the list of some:

- Plugin package manager with [Lazy.nvim](https://github.com/folke/lazy.nvim).
- Code, snippet, word auto-completion via
  [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- Language server protocol (LSP) and Linting support:
  [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) and
  [Mason](https://github.com/williamboman/mason.nvim).
  - Supported languages: `bash`, `yaml`, `python`, `docker`, `json`, `lua`,
    `helm`, `toml`, `markdown`, `ansible`, `terraform`
- Git integration via [gitsigns](https://github.com/lewis6991/gitsigns.nvim) and
  [lazygit](https://github.com/jesseduffield/lazygit)
- Faster matching pair insertion and jump via
  [nvim-autopairs](https://github.com/windwp/nvim-autopairs).
- File tree explorer via
  [neotree](https://github.com/nvim-neo-tree/neo-tree.nvim).
- Code highlighting via
  [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
- Markdown writing and previewing via
  [render-markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim)
  and [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim).
- Cursor IDE like AI experience with
  [Avante-nvim](https://github.com/yetone/avante.nvim)
- Copilot integration
- Undo management via [undotree](https://github.com/simnalamburt/vim-mundo)
- Quick navigation to specific word with
  [Leap](https://github.com/ggandor/leap.nvim)
- Multiple new keymaps and features to base vim using
  [Mini](https://github.com/echasnovski/mini.nvim)
- Tmux integration with [nvim-tmux](https://github.com/aserowy/tmux.nvim) and
  [nvim-tmux-navigator](https://github.com/alexghergh/nvim-tmux-navigation)
- Rainbow for colorizing brackets
  [Rainbow](https://github.com/HiPhish/rainbow-delimiters.nvim)

## Pre-requisites

- Make sure you have following binaries in your $PATH. There may be more
  packages necessary but installing following ones worked for me to get started
  with this neovim configuration:
  1. npm
  1. [fzf](https://github.com/junegunn/fzf)
  1. [zoxide](https://github.com/ajeetdsouza/zoxide)
  1. [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)
  1. [Yazi](https://github.com/sxyazi/yazi)- for quick and easy file switching
     and navigation. Recommended terminals that are more compatible with yazi:
     wezterm or iterm2.
  1. [Nerd Font](https://www.nerdfonts.com/) - visually more pleasing & allows
     icons: `brew install font-meslo-lg-nerd-font`
  1. [Shellcheck](https://github.com/koalaman/shellcheck) in your $PATH- for
     automatic bash linting
  1. [lazygit](https://github.com/jesseduffield/lazygit)

## Usage

- Here are some useful shortcuts that I often use. I have listen only some
  portion in this documentation. All keymaps can be looked up with the leader
  `Space` key in combination with
  [which-key](https://github.com/folke/which-key.nvim) plugin

### Navigation

#### Window-management

1. ss - Split window horizontally (regular ss)
1. sv - Split window vertically (regular sv)
1. C-{h,j,k,l} - Move to window in direction
1. `M-{h,j,k,l}` - Resize window in direction

#### Tmux

1. `tv` - Open a new tmux vertical split `th` same for horizontal
1. `<tmux leader>+M` - hide/maximise window (useful for opening/closing terminal
   in neovim for example)

### Code management

- `cg` - CodeGrep, fzf grep in currently opened file
- `ff` - Fzf find files
- `f{g,G}` - grep through files
- `,` Navigate between buffers (replaces tabs for me)
- `yy` - Open up Yazi file manager
- `mp` - Markdown preview
- `{e,E}` - Open neotree

## Further useful sources

- [Using Neovim for Three years](https://jdhao.github.io/2021/12/31/using_nvim_after_three_years/)
- [Typecraft - tmux will skyrocket your productivity](https://typecraft.com/blog/tmux-will-skyrocket-your-productivity)
