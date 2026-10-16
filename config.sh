#!/usr/bin/env bash

# Update the checkout this script lives in (normally `~/.claude`), then the
# Claude Code plugins and marketplaces it uses.
#
# Usage:
#
#     ./config.sh [--dry-run]
#     ./config.sh --help
#
# What it does, in order:
#
#   1. Refuse when the working tree has uncommitted changes to tracked files,
#      HEAD is detached, or the current branch has no upstream.
#   2. `git fetch --prune`, then refuse when the branch has diverged from its
#      upstream and so cannot fast-forward, or when a local file or directory
#      holding nothing tracked at HEAD, ignored or not, sits at a path the
#      incoming commits add, or such a file at a parent path of one.
#   3. Fast-forward the current branch to its upstream.
#   4. Run `plugins.sh --update` from this directory, i.e. the copy step 3
#      just pulled, and exit with its status. VERBOSE reaches it through the
#      environment.
#
# A refusal prints why, exits non-zero, and leaves the branch and working
# tree as they were. The script never stashes and never switches branches.
#
# Untracked files do not count as uncommitted changes: `~/.claude` holds
# local state, most of it gitignored. Only one at a path the incoming commits
# add, or at a parent path of one, matters, and step 2 checks for it because
# git does not: a fast-forward overwrites an ignored file at such a path, or
# deletes a directory holding only ignored files there, without a word.
#
# `--dry-run` fetches, prints the incoming commits and their diffstat, does
# not pull, and runs `plugins.sh --update --dry-run`. The same refusals apply.

set -euo pipefail

# --- Output helpers (mirrors plugins.sh) -----------------------------------

info()       { echo "-> $1"; }
success()    { echo "[ok] $1"; }
warn()       { echo "Warning: $1" >&2; }
error_exit() { echo "Error: $1" >&2; exit 1; }

# --- Usage -----------------------------------------------------------------

usage() {
    cat <<'EOF'
Update this Claude config checkout, then its plugins and marketplaces.

Usage:
  ./config.sh             Fast-forward the current branch to its upstream,
                          then run ./plugins.sh --update
  ./config.sh --dry-run   Fetch and show the incoming commits without
                          pulling, then run ./plugins.sh --update --dry-run
  ./config.sh --help      Show this help

Refuses, changing nothing, on uncommitted changes to tracked files, a
detached HEAD, a branch with no upstream, a branch that cannot
fast-forward to its upstream, or an untracked or ignored local file or
directory at a path the incoming commits add, or such a file at a parent
path of one.

Environment:
  VERBOSE=1   Passed through to plugins.sh.
EOF
}

# --- Main ------------------------------------------------------------------

main() {
    local dry_run=0 help=0

    # Every argument is checked before --help acts on any.
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) dry_run=1 ;;
            --help) help=1 ;;
            *) error_exit "unexpected argument: $1 (try --help)" ;;
        esac
        shift
    done
    [[ "$help" == 1 ]] && { usage; exit 0; }

    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    command -v git >/dev/null 2>&1 || error_exit "git not found on PATH"

    if [[ -n "$(git -C "$dir" status --porcelain --untracked-files=no)" ]]; then
        error_exit "$dir has uncommitted changes; commit or discard them first"
    fi

    local branch
    branch=$(git -C "$dir" symbolic-ref -q --short HEAD) \
        || error_exit "$dir has a detached HEAD; check out a branch first"

    local upstream
    upstream=$(git -C "$dir" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null) \
        || error_exit "branch $branch in $dir has no upstream"

    info "Fetching $upstream"
    git -C "$dir" fetch --prune

    if ! git -C "$dir" merge-base --is-ancestor HEAD '@{u}'; then
        git -C "$dir" merge-base --is-ancestor '@{u}' HEAD \
            || error_exit "branch $branch has diverged from $upstream; cannot fast-forward"
        warn "branch $branch is ahead of $upstream; nothing to pull"
    fi

    # A path the incoming commits add blocks when a local file or directory, a
    # symlink included, sits at it, and a parent path of one blocks when a local
    # non-directory does; either only when nothing is tracked at or under the
    # path. Content tracked at or under the path is git's to replace, as when
    # upstream turns a tracked directory into a file. With core.ignorecase,
    # tracked content matches case-insensitively, so a case-only rename
    # upstream does not block. The three-dot range diffs from the merge base,
    # so a branch ahead of its upstream adds nothing here.
    local pathspec_magic=literal
    if [[ "$(git -C "$dir" config --bool core.ignorecase || true)" == true ]]; then
        pathspec_magic=literal,icase
    fi

    local path parent candidate candidates clobbered=() seen=$'\n'
    while IFS= read -r -d '' path; do
        candidates=()
        if [[ -L "$dir/$path" || -e "$dir/$path" ]]; then
            candidates+=("$path")
        fi
        parent=$path
        while [[ "$parent" == */* ]]; do
            parent=${parent%/*}
            if [[ -L "$dir/$parent" || ( -e "$dir/$parent" && ! -d "$dir/$parent" ) ]]; then
                candidates+=("$parent")
            fi
        done
        for candidate in ${candidates[@]+"${candidates[@]}"}; do
            [[ "$seen" == *$'\n'"$candidate"$'\n'* ]] && continue
            seen+="$candidate"$'\n'
            # The clean-tree check above makes the index match HEAD.
            if [[ -z "$(git -C "$dir" ls-files -- ":($pathspec_magic)$candidate")" ]]; then
                clobbered+=("$candidate")
            fi
        done
    done < <(git -C "$dir" diff --name-only --no-renames --diff-filter=A -z 'HEAD...@{u}')
    if [[ ${#clobbered[@]} -gt 0 ]]; then
        printf '  %s\n' "${clobbered[@]}" >&2
        error_exit "$upstream adds files at or under the paths above, where $dir holds an untracked or ignored file or directory; move each aside first"
    fi

    if [[ "$dry_run" == 1 ]]; then
        info "Incoming commits from $upstream:"
        git -C "$dir" log --oneline 'HEAD..@{u}'
        # Three dots: the incoming commits' changes, not HEAD's commits undone.
        git -C "$dir" diff --stat 'HEAD...@{u}'
        info "Dry run: not pulling"
        exec "$dir/plugins.sh" --update --dry-run
    fi

    info "Fast-forwarding $branch to $upstream"
    git -C "$dir" merge --ff-only '@{u}'
    success "$dir is up to date with $upstream"

    # exec, so bash reads nothing more from this file, which the merge above
    # may have replaced.
    exec "$dir/plugins.sh" --update
}

main "$@"
