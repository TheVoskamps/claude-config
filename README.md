# claude-config

This repo contains the shared configuration of `~/.claude` and is meant
to be used by and in conjunction with `TheVoskamps/macos-setup`
functionality.

## Install into `~/.claude`

This repo can become your `~/.claude` directly. Clone it somewhere, then
run the bundled install script from inside the clone:

```sh
git clone git@github.com:TheVoskamps/claude-config.git
cd claude-config
./install.sh
```

The HTTPS clone URL works too:

```sh
git clone https://github.com/TheVoskamps/claude-config.git
```

### What the install script does

In order:

1. **Backs up** any existing `~/.claude/` by moving it aside to a
   timestamped `~/.claude.backup.<timestamp>/` (for example
   `~/.claude.backup.20260524_224418/`).
2. **Installs** the clone by moving the whole clone — including its
   intact `.git` and `origin` pointing at the source repo — to
   `~/.claude/`. After this, `~/.claude/` is a live git clone you can
   update later with `~/.claude/config.sh` (see [Updating](#updating)).
3. **Additively restores** your previous `~/.claude/` files on top of
   the freshly-installed clone, **local wins**: any file you already had
   overwrites the clone's version where they collide, and the clone's
   `.git` is never touched. Allowlisted files that differ from the repo's
   tracked version then show as modified in `git -C ~/.claude status`;
   files this repo's `.gitignore` excludes (local state, caches,
   `projects/`, etc.) are restored but stay untracked and do not show up.

### Recovery and safety

- The timestamped `~/.claude.backup.<timestamp>/` is always the recovery
  path. The script never deletes it.
- The script is **safe to re-run** and **non-destructive**. If
  `~/.claude/` is already a clone of the source repo, it reports that
  and exits without moving anything or creating another backup. That
  check compares only the `<owner>/<repo>` part of the origin, so SSH
  and HTTPS origins both match regardless of letter case, and a
  `~/.claude/` cloned under one of this repo's earlier names still
  counts as installed.
- It refuses to run when started from inside `~/.claude/` itself — once
  installed, update the canonical copy with `~/.claude/config.sh`
  rather than re-running the installer.

### Updating

`config.sh` updates the checkout it lives in, normally `~/.claude`, and
then its plugins:

```sh
~/.claude/config.sh            # pull, then ./plugins.sh --update
~/.claude/config.sh --dry-run  # show what would change, pull nothing
```

It fetches with prune, fast-forwards the current branch to its
upstream, and then runs `plugins.sh --update` from the freshly pulled
copy, exiting with its status. `VERBOSE=1` passes through to
`plugins.sh`.

It refuses, printing why and changing nothing, when:

- a tracked file has uncommitted changes;
- HEAD is detached, or the current branch has no upstream;
- the branch has diverged from its upstream and cannot fast-forward;
- an untracked or ignored local file sits at a path the incoming
  commits add, which a fast-forward would otherwise overwrite.

It never stashes and never switches branches. Untracked files elsewhere
do not block it.

`--dry-run` fetches, prints the incoming commits and their diffstat,
leaves HEAD where it is, and runs `plugins.sh --update --dry-run`. The
same refusals apply.

## Managing plugins

`plugins.sh` is a companion to `install.sh` that installs or updates
Claude Code marketplaces and plugins through the `claude plugin` CLI:

```sh
./plugins.sh --install            # add marketplaces, then install plugins
./plugins.sh --update             # update marketplaces and plugins in place
./plugins.sh --install --dry-run  # print the commands without running them
```

- `--install` reads the `extraKnownMarketplaces` and `enabledPlugins`
  blocks of `~/.claude/settings.json`, adds each marketplace (deriving
  the source argument from its `source` block), and then installs every
  enabled plugin.
- `--update` reads the `claude` CLI's own listings, so marketplaces and
  plugins from every settings source count: it updates each marketplace
  `claude plugin marketplace list --json` names, and each plugin
  `claude plugin list --json` reports as enabled, once even when it is
  enabled in more than one scope.
- `--dry-run` combines with either mode to print the `claude` commands
  that would run without executing any of them. With `--update` it
  still runs the two read-only listings.

`--update` is quiet: an item that was already up to date prints nothing,
so a fully-synced run shows only its two section headers and the closing
`[ok]` line. Set `VERBOSE=1` to see every per-item label and the full
`claude plugin` output instead:

```sh
VERBOSE=1 ./plugins.sh --update
```

Only stdout is filtered, so a failing item still shows the `claude`
error text on stderr, its own `Warning: failed: ...` line, and an entry
in the closing summary. `--install` is never filtered — adding a
marketplace or installing a plugin is a real change worth reading.

Per-item failures are collected rather than fatal: every marketplace and
plugin is attempted, a summary lists any failures at the end, and the
script exits non-zero if any failed. It requires `jq` and `claude` on
`PATH`.

## Contributing

This is a public repository. Contributions are welcome:

- **Fork** the repository and create a feature branch from the default
  branch.
- **Open a pull request** from your fork. PRs require a passing CI run,
  code-owner review (`@evoskamp`), and all review conversations
  resolved before they can merge.
- **File an issue** to report a bug or propose a change. Any logged-in
  GitHub user can open and comment on issues.

Outside contributors have read access: you can fork, open PRs from your
fork, and file/comment on issues. Push access, merging, and issue
triage are reserved for maintainers.
