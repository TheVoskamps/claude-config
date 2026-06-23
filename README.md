# global-claude-config

This repo contains the shared configuration of `~/.claude` and is meant
to be used by and in conjunction with `TheVoskamps/macos-setup`
functionality.

## Install into `~/.claude`

This repo can become your `~/.claude` directly. Clone it somewhere, then
run the bundled install script from inside the clone:

```sh
git clone git@github.com:TheVoskamps/global-claude-config-mirrored-to-public.git
cd global-claude-config-mirrored-to-public
./install.sh
```

The HTTPS clone URL works too:

```sh
git clone https://github.com/TheVoskamps/global-claude-config-mirrored-to-public.git
```

### What the install script does

In order:

1. **Backs up** any existing `~/.claude/` by moving it aside to a
   timestamped `~/.claude.backup.<timestamp>/` (for example
   `~/.claude.backup.20260524_224418/`).
2. **Installs** the clone by moving the whole clone — including its
   intact `.git` and `origin` pointing at the source repo — to
   `~/.claude/`. After this, `~/.claude/` is a live git clone you can
   update later with `git -C ~/.claude pull`.
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
  and exits without moving anything or creating another backup.
- It refuses to run when started from inside `~/.claude/` itself — once
  installed, update the canonical copy with `git -C ~/.claude pull`
  rather than re-running the installer.

## Managing plugins

`plugins.sh` is a companion to `install.sh` that installs or updates the
Claude Code marketplaces and plugins declared in a `settings.json`
(default `~/.claude/settings.json`). It reads the `extraKnownMarketplaces`
and `enabledPlugins` blocks and drives the `claude plugin` CLI:

```sh
./plugins.sh --install            # add marketplaces, then install plugins
./plugins.sh --update             # update marketplaces and plugins in place
./plugins.sh --install --dry-run  # print the commands without running them
```

A `SETTINGS_FILE` may be passed as a positional argument to read a
settings file other than `~/.claude/settings.json`.

- `--install` adds each marketplace (deriving the source argument from
  its `source` block) and then installs every enabled plugin.
- `--update` updates each marketplace and every enabled plugin in place.
- `--dry-run` combines with either mode to print the `claude` commands
  that would run without executing any of them.

Per-item failures are collected rather than fatal: every marketplace and
plugin is attempted, a summary lists any failures at the end, and the
script exits non-zero if any failed. It requires `jq` and `claude` on
`PATH`.
