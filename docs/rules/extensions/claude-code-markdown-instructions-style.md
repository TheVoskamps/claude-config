# Claude Code Markdown Instructions Style — this repo

## A relocated file keeps its `settings.json` allowlist coverage

For every file the diff moves between this repo's top-level
directories, `settings.json`'s `permissions.allow` carries a glob
matching the deployed `~/.claude/` path of the new location, or the
PR body flags the path left uncovered.
