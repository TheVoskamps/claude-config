# Claude Code Markdown Instructions Style — this repo

## A relocated file keeps its `settings.json` allowlist coverage

For every file the diff moves between this repo's top-level
directories, `settings.json`'s `permissions.allow` carries a glob
matching the deployed `~/.claude/` path of the new location, or the
PR body flags the path left uncovered.

## A new rules file is announced in `CLAUDE.md` per its directory

Every file the diff adds under `rules/` has an `@` line in
`CLAUDE.md`, and every file the diff adds under `docs/rules/` has a
plain-path entry there.
