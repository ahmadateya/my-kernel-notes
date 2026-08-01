#!/usr/bin/env bash
#
#   nsync                     sync + commit + push
#   nsync "exec path"         نفس الحاجة برسالة commit
#   nsync -- blame fs/exec.c  أي أمر git على repo النوتس
#
set -euo pipefail

# -- change this
GIT_DIR_PATH="${KERNEL_NOTES_GIT:-$HOME/Desktop/linux_work/my-kernel-notes.git}"

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TREE="$(dirname "$SELF")"     

MINE=(_notes _scripts .vscode .gitignore README.md)
# ------------------------

G=(git --git-dir="$GIT_DIR_PATH" --work-tree="$TREE")
[ -d "$GIT_DIR_PATH" ] || { echo "nsync: no notes in $GIT_DIR_PATH" >&2; exit 1; }
cd "$TREE"

if [ "${1:-}" = "--" ]; then shift; exec "${G[@]}" "$@"; fi

git diff --name-only HEAD -z | while IFS= read -r -d '' p; do
    [ -e "$p" ] && printf '%s\0' "$p"
done | xargs -0 -r "${G[@]}" add -f --

for p in "${MINE[@]}"; do
    [ -e "$p" ] && "${G[@]}" add -f -- "$p"
done

"${G[@]}" add -u

if "${G[@]}" diff --cached --quiet; then echo "nothing to sync"; exit 0; fi

"${G[@]}" commit -q -m "${1:-sync $(date '+%Y-%m-%d %H:%M')}"
"${G[@]}" push -q 2>/dev/null || echo "nsync: failed to push" >&2
"${G[@]}" log --oneline -1