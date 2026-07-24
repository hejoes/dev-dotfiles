# ABOUTME: zsh wrapper making `cs` default to adopting the CURRENT directory as
# ABOUTME: the session (run Claude in your project folder) instead of an isolated
# ABOUTME: ~/.claude-sessions/<name> workspace. Source this from ~/.zshrc.
#
# Behaviour:
#   cs                 in a git project -> adopt this folder (name = folder name)
#                                          and launch Claude here
#   cs <name>          in a git project, name unused -> adopt this folder AS <name>
#   cs <name>          when <name> already exists    -> resume it (session list intact)
#   cs (in an adopted/session dir already)           -> resume in place
#   cs -ls / -adopt / -search / -secrets / ... (any -flag) -> passed straight through
#
# Safety: never auto-adopts $HOME or a non-git directory, because `cs -adopt`
# runs `git init` + `git add -A` + a commit — harmless in a real repo, a mess in
# a random folder. In those cases it falls back to plain cs behaviour.
cs() {
    local root="${CS_SESSIONS_ROOT:-$HOME/.claude-sessions}"

    # Global subcommands (-ls, -adopt, -search, -secrets, -rm, -live, ...) and
    # anything starting with '-' go straight to the real binary, untouched.
    if [ $# -gt 0 ] && [ "${1#-}" != "$1" ]; then
        command cs "$@"
        return
    fi

    # Session name: explicit first arg wins, else the current folder's name.
    local name="${1:-${PWD:t}}"

    # Already sitting in a cs session (workspace or adopted project) -> resume.
    if [ -d "$PWD/.cs" ]; then
        command cs "$name"
        return
    fi

    # A session by this name already exists -> resume it (keeps the session-list
    # workflow: `cs myproject` from anywhere reopens the existing session).
    if [ -e "$root/$name" ]; then
        command cs "$name"
        return
    fi

    # Auto-adopt only real project dirs: must be inside a git work tree and not
    # $HOME. Otherwise fall back to stock cs behaviour.
    if [ "$PWD" != "$HOME" ] && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        command cs -adopt "$name" && command cs "$name"
    else
        command cs "$@"
    fi
}
