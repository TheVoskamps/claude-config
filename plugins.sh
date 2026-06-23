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

SETTINGS_FILE defaults to ~/.claude/settings.json.
EOF
}

# --- Failure accounting ----------------------------------------------------
# Collect "context: item" strings for anything that failed; report at the end.

FAILURES=()
DRY_RUN=0

# Run a claude command for one item; record a failure instead of aborting.
# In dry-run mode, print the command that would run and execute nothing.
#   run_item "<human label>" claude plugin ...
run_item() {
    local label="$1"; shift
    if [[ "$DRY_RUN" == 1 ]]; then
        echo "[dry-run] $*"
        return 0
    fi
    info "$label"
    if ! "$@"; then
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
        select(.value == true or .value.enabled == true) | .key
    ' "$SETTINGS"
}

# --- Modes -----------------------------------------------------------------

do_update() {
    info "Updating marketplaces from $SETTINGS"
    local name found=0
    while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        found=1
        run_item "marketplace update: $name" \
            claude plugin marketplace update "$name"
    done < <(marketplace_names)
    [[ "$found" == 0 ]] && warn "no marketplaces in .extraKnownMarketplaces; skipping"

    info "Updating plugins from $SETTINGS"
    local plugin
    found=0
    while IFS= read -r plugin; do
        [[ -z "$plugin" ]] && continue
        found=1
        run_item "plugin update: $plugin" \
            claude plugin update "$plugin"
    done < <(enabled_plugins)
    [[ "$found" == 0 ]] && warn "no enabled plugins in .enabledPlugins; skipping"
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
    [[ "$found" == 0 ]] && warn "no marketplaces in .extraKnownMarketplaces; skipping"

    info "Installing plugins from $SETTINGS"
    local plugin
    found=0
    while IFS= read -r plugin; do
        [[ -z "$plugin" ]] && continue
        found=1
        run_item "plugin install: $plugin" \
            claude plugin install "$plugin"
    done < <(enabled_plugins)
    [[ "$found" == 0 ]] && warn "no enabled plugins in .enabledPlugins; skipping"
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
