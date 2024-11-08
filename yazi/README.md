# Yazi

- This is my default file navigator that almost replaces finder on my Mac. I'ts
  quite useful for moving/pasting and opening up/searching files with fzf and
  zoxide. Works also great along with neovim.

[source](https://yazi-rs.github.io/features)

## Prerequisites

- [Yazi-installation](https://yazi-rs.github.io/docs/installation)
- Yazi's Image preview is not available on Alacritty. List of supported
  terminals can be found: https://yazi-rs.github.io/docs/image-preview

## Tips

1. If typing `yazi` inside terminal sounds too long, you can map it as `yy` in
   `~/.zshrc`:

```sh
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
```

2. `!` opens up terminal in current directory where yazi is opened.
