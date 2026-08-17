#!/usr/bin/env bash

# Install or update the Claude Code plugins and marketplaces declared in a
# settings.json (default `~/.claude/settings.json`).
#
# Usage:
#
#     ./plugins.sh --install [SETTINGS_FILE]
#     ./plugins.sh --update  [SETTINGS_FILE]
#     ./plugins.sh --help
#
# Add `--dry-run` to either mode to print the `claude` commands that would run
# without executing any of them.
#
# Both modes read the same two blocks from SETTINGS_FILE:
#
#   - `.extraKnownMarketplaces` — a map of marketplace-name -> { source, ... }.
#   - `.enabledPlugins`         — a map of `<plugin>@<marketplace>` -> enabled.
#     A plugin counts as enabled when its value is `true` or `.enabled == true`.
#
# What each mode does:
#
#   --update   Refresh marketplaces and plugins already present.
#                marketplace: `claude plugin marketplace update <name>`
#                plugin:      `claude plugin update <plugin@marketplace>`
#
#   --install  Add marketplaces, then install enabled plugins.
#                marketplace: `claude plugin marketplace add <source-arg>`
#                  The <source-arg> is derived from each marketplace's
#                  `.source` block: `.source.repo` for a github source, else
#                  `.source.url` or `.source.path` — i.e. exactly what
#                  `claude plugin marketplace add` expects for that source
#                  type. `add` is idempotent (it re-points an existing entry).
#                plugin:      `claude plugin install <plugin@marketplace>`
#
# Per-item failures do NOT abort the run: every marketplace and plugin is
# attempted, failures are collected, and a summary is printed at the end. The
# script exits non-zero if any item failed.
#
# --update is quiet by default: an item that was already up to date prints
# nothing, so a fully-synced run reports only its two section headers and the
# final `[ok]` line. Set VERBOSE=1 to see every per-item label and the full
# `claude plugin ...` stdout. Only stdout is filtered — stderr, warnings, and
# the failure summary always pass through.

set -euo pipefail

# --- Output helpers (mirrors install.sh) -----------------------------------

info()       { echo "-> $1"; }
success()    { echo "[ok] $1"; }
warn()       { echo "Warning: $1" >&2; }
error_exit() { echo "Error: $1" >&2; exit 1; }

# --- Usage -----------------------------------------------------------------

usage() {
    cat <<'EOF'
Install or update Claude Code plugins/marketplaces from a settings.json.

Usage:
  ./plugins.sh --install [SETTINGS_FILE]   Add marketplaces, install plugins
  ./plugins.sh --update  [SETTINGS_FILE]   Update marketplaces and plugins
  ./plugins.sh --help                      Show this help

Options:
  --dry-run   Print the claude commands that would run; execute nothing.

Environment:
  VERBOSE=1   Do not quiet --update: print every per-item label and the
              full claude plugin output, including no-op progress chatter.

SETTINGS_FILE defaults to ~/.claude/settings.json.
EOF
}

# --- Failure accounting ----------------------------------------------------
# Collect "context: item" strings for anything that failed; report at the end.

FAILURES=()
DRY_RUN=0

# --- Quiet mode ------------------------------------------------------------
# QUIET is turned on by do_update (see below) unless VERBOSE=1 is set in the
# environment or --dry-run is in effect. --install leaves it off: adding a
# marketplace or installing a plugin is a real change, and its output is worth
# reading.

VERBOSE="${VERBOSE:-0}"
QUIET=0

# stdout lines the `claude plugin ...` commands print while doing nothing:
# progress chatter, plus the "nothing to do" verdict itself.
QUIET_PATTERNS='Refreshing marketplace cache|Successfully updated marketplace|Checking for updates for plugin|is already at the latest version'

# Run "$@" with the no-op chatter dropped from its stdout, and return the exit
# status of "$@" itself rather than grep's.
#
# grep exits 1 when it emits nothing, which is exactly what an up-to-date item
# looks like, so grep's status must not be mistaken for the command's. Reading
# PIPESTATUS[0] on the line right after the pipeline is what keeps a real
# `claude` failure visible. That also rules out the `| grep ... || true` form:
# `true` is itself a pipeline, so it would overwrite PIPESTATUS before it could
# be read.
#
# Call this only from a context where errexit is disabled (an `if` condition, a
# `!` negation, or the left side of `||`, as run_item does) so the failing
# pipeline does not abort the whole run under `set -e`.
#
# stderr is not piped, so genuine error text still reaches the terminal.
run_quiet() {
    local status
    "$@" | grep -Ev "$QUIET_PATTERNS"
    status=${PIPESTATUS[0]}
    return "$status"
}

# Run a claude command for one item; record a failure instead of aborting.
# In dry-run mode, print the command that would run and execute nothing.
# In quiet mode, the per-item label is printed only when the item fails —
# an up-to-date item is silent end to end.
#   run_item "<human label>" claude plugin ...
run_item() {
    local label="$1"; shift
    if [[ "$DRY_RUN" == 1 ]]; then
        echo "[dry-run] $*"
        return 0
    fi
    local ok=1
    if [[ "$QUIET" == 1 ]]; then
        run_quiet "$@" || ok=0
    else
        info "$label"
        "$@" || ok=0
    fi
    if [[ "$ok" == 0 ]]; then
        warn "failed: $label"
        FAILURES+=("$label")
    fi
}

# --- jq extractors ---------------------------------------------------------

# Echo each marketplace name (key of .extraKnownMarketplaces), one per line.
marketplace_names() {
    jq -r '(.extraKnownMarketplaces // {}) | keys[]' "$SETTINGS"
}

# Echo, for each marketplace, "<name>\t<add-source-arg>" where the source arg
# is derived from its `.source` block (repo for github, else url or path).
# A marketplace whose source yields no usable argument is emitted with an
# empty second field, so the caller can warn and skip it.
marketplace_add_args() {
    jq -r '
        (.extraKnownMarketplaces // {}) | to_entries[] |
        .key as $name |
        (.value.source // {}) as $s |
        ($s.repo // $s.url // $s.path // "") as $arg |
        "\($name)\t\($arg)"
    ' "$SETTINGS"
}

# Echo each enabled plugin key, one per line.
enabled_plugins() {
    jq -r '
        (.enabledPlugins // {}) | to_entries[] |
        select(.value == true or ((.value | type) == "object" and .value.enabled == true)) | .key
    ' "$SETTINGS"
}

# --- Modes -----------------------------------------------------------------

do_update() {
    # Quiet the no-op chatter unless the caller asked for everything. Dry-run
    # output is a listing of commands, not command output, so leave it alone.
    if [[ "$VERBOSE" != 1 && "$DRY_RUN" != 1 ]]; then
        QUIET=1
    fi

    info "Updating marketplaces from $SETTINGS"
    local name found=0
    while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        found=1
        run_item "marketplace update: $name" \
            claude plugin marketplace update "$name"
    done < <(marketplace_names)
    if [[ "$found" == 0 ]]; then
        warn "no marketplaces in .extraKnownMarketplaces; skipping"
    fi

    info "Updating plugins from $SETTINGS"
    local plugin
    found=0
    while IFS= read -r plugin; do
        [[ -z "$plugin" ]] && continue
        found=1
        run_item "plugin update: $plugin" \
            claude plugin update "$plugin"
    done < <(enabled_plugins)
    if [[ "$found" == 0 ]]; then
        warn "no enabled plugins in .enabledPlugins; skipping"
    fi
}

do_install() {
    info "Adding marketplaces from $SETTINGS"
    local name arg found=0
    while IFS=$'\t' read -r name arg; do
        [[ -z "$name" ]] && continue
        found=1
        if [[ -z "$arg" ]]; then
            warn "marketplace '$name' has no usable .source (repo/url/path); skipping"
            FAILURES+=("marketplace add: $name (no source)")
            continue
        fi
        run_item "marketplace add: $name ($arg)" \
            claude plugin marketplace add "$arg"
    done < <(marketplace_add_args)
    if [[ "$found" == 0 ]]; then
        warn "no marketplaces in .extraKnownMarketplaces; skipping"
    fi

    info "Installing plugins from $SETTINGS"
    local plugin
    found=0
    while IFS= read -r plugin; do
        [[ -z "$plugin" ]] && continue
        found=1
        run_item "plugin install: $plugin" \
            claude plugin install "$plugin"
    done < <(enabled_plugins)
    if [[ "$found" == 0 ]]; then
        warn "no enabled plugins in .enabledPlugins; skipping"
    fi
}

# --- Main ------------------------------------------------------------------

main() {
    local mode="" settings_arg=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install) mode="install" ;;
            --update)  mode="update" ;;
            --dry-run) DRY_RUN=1 ;;
            -h|--help) usage; exit 0 ;;
            --) shift; break ;;
            -*) error_exit "unknown option: $1 (try --help)" ;;
            *)
                [[ -n "$settings_arg" ]] && error_exit "unexpected extra argument: $1"
                settings_arg="$1"
                ;;
        esac
        shift
    done
    # A SETTINGS_FILE after `--`.
    [[ $# -gt 0 ]] && { settings_arg="$1"; shift; }
    [[ $# -gt 0 ]] && error_exit "unexpected extra argument: $1"

    [[ -z "$mode" ]] && { usage >&2; error_exit "exactly one of --install or --update is required"; }

    SETTINGS="${settings_arg:-$HOME/.claude/settings.json}"

    # Preconditions.
    command -v jq     >/dev/null 2>&1 || error_exit "jq not found on PATH"
    command -v claude >/dev/null 2>&1 || error_exit "claude not found on PATH"
    [[ -f "$SETTINGS" ]] || error_exit "settings file not found: $SETTINGS"
    jq -e . "$SETTINGS" >/dev/null 2>&1 || error_exit "settings file is not valid JSON: $SETTINGS"

    case "$mode" in
        install) do_install ;;
        update)  do_update ;;
    esac

    echo
    if [[ ${#FAILURES[@]} -gt 0 ]]; then
        warn "${#FAILURES[@]} item(s) failed:"
        local f
        for f in "${FAILURES[@]}"; do
            echo "  - $f" >&2
        done
        exit 1
    fi
    if [[ "$DRY_RUN" == 1 ]]; then
        success "Dry run complete for mode: $mode (no commands executed)"
    else
        success "All plugin operations completed for mode: $mode"
    fi
}

main "$@"
