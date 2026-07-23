#!/usr/bin/env bash
# ABOUTME: Custom Claude Code statusLine — reuses the cs-statusline engine but drops the
# ABOUTME: cost/price pill and appends a current-working-directory path pill at the end.
#
# It sources the installed cs-statusline as a *library* (its documented
# CS_STATUSLINE_LIB seam), so every colour/gradient/width helper is reused and
# only the segment list changes. cs leaves this registration alone because it is
# not the path "…/cs-statusline" (see cs `_strip_statusline_registration`).
#
# Segments can still be overridden with CS_STATUSLINE_SEGMENTS. Default order:
#   logo,session,notes,pane,git,model,ctx,limits,dir   (note: no `cost`)
set -uo pipefail

CS_SL="${CS_STATUSLINE_BIN:-$HOME/.local/bin/cs-statusline}"
# Fallback to a bare basename if cs-statusline is missing (e.g. cs not installed
# yet on a freshly-synced machine) so the bar never breaks.
if [ ! -r "$CS_SL" ]; then printf '%s\n' "${PWD##*/}"; exit 0; fi

# Load helpers without rendering (defines _add, _seg_*, _render, palette, …).
CS_STATUSLINE_LIB=1 source "$CS_SL"

# New segment: the session's scoped path, home-abbreviated, on a quiet surface
# pill (the same muted background the cost pill used). Prefers CLAUDE_SESSION_DIR
# — the workspace root cs pins for the session — so it shows where the session is
# anchored (where you ran `cs` from) and stays stable even if Claude cd's around.
# Falls back to the live statusline cwd, then $PWD, for non-cs Claude sessions.
_seg_dir() {
    local d="${CLAUDE_SESSION_DIR:-${SL_DIR:-$PWD}}"
    [ -n "$d" ] || return 0
    case "$d" in "$HOME"*) d="~${d#$HOME}";; esac
    _add "$d" "surface"
}

# Replicate cs-statusline's main() flow, minus `cost`, plus `dir` at the end.
[ "${CS_STATUSLINE_DISABLE:-}" = "1" ] && exit 0
_NOW=""; _SL_NOW_READY=""
_read_stdin
_parse_stdin "$_STDIN" || _fallback
_detect_level

segments="${CS_STATUSLINE_SEGMENTS:-logo,session,notes,pane,git,model,ctx,limits,dir}"
IFS=',' read -ra names <<< "$segments"
for name in "${names[@]}"; do
    case "$name" in
        logo)    _seg_logo ;;
        session) _seg_session ;;
        notes)   _seg_notes ;;
        pane)    _seg_pane ;;
        ctx)     _seg_ctx ;;
        model)   _seg_model ;;
        git)     _seg_git ;;
        limits)  _seg_limits ;;
        cost)    _seg_cost ;;
        dir)     _seg_dir ;;
    esac
done
_render
