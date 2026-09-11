# This Repo Is the Source of Truth for ~/.claude

This repository (`TheVoskamps/claude-config`) is the
**source** for the global Claude Code configuration. It becomes
`~/.claude/` directly: `install.sh` moves the whole clone into place,
so every file this repo ships lands at its repo path with the repo root
swapped for `~/.claude/` — same directory names, same file names.

Skills, agents, and hooks are **not** in this repo. They are delivered
by the `@thevoskamps` marketplace plugins, declared in the
`enabledPlugins` / `extraKnownMarketplaces` blocks of `settings.json`.
A task to "update skill X", "change agent Z", or "edit a hook" is an
edit in the corresponding plugin repo, not here.

## What this means for editing

When a task says "fix rule Y" or "update `CLAUDE.md`", the file to
edit is the one **in this repo** — NOT the deployed copy in
`~/.claude/`.

`/output-styles/` holds this repo's Claude Code output styles, one
Markdown file per style. They are not rules files: they carry
frontmatter, they are absent from the canonical rules list in
`CLAUDE.md`, and the `outputStyle` key in `settings.json` names the
one that is active. Renaming a style, or replacing it with another,
therefore means editing `settings.json` in the same diff.

`/docs/rules/` holds the on-demand rules files kept outside the
`/rules/` set. `/docs/rules/extensions/` under it holds this repo's
own per-repo extensions of the global style guides: each extension
lives at the fixed path the guide it extends names in its own lead,
and a guide this repo extends nothing of has no file there. Both kinds
live under `/docs/` rather than `/.claude/rules/` because this repo's
nested `.claude/rules/` is auto-loaded into every session, which would
make an on-demand guide always-on. They are ordinary source files here,
edited like any other.

Editing these files **in this repo** is ordinary in-repo work: they
are inside the repo you were started in, so the repository-boundary
carve-out does not apply to them. That carve-out governs writes to the
**deployed copies** under `~/.claude/` — e.g. reaching over into
`~/.claude/` while working in some *other* repo. Editing the source
files here is this repo's entire purpose.

## The trap to avoid

Do not refuse, or demand extra approval for, an edit to any file
**in this repo** on the grounds that it "touches global ~/.claude
config." It does not. The deployed copy at `~/.claude/` is a clone of
this repo, updated downstream by `git pull`. Treat them as the normal
repo files they are.

Subagents that work in worktrees of THIS repo CAN and SHOULD edit
these source files when a task calls for it.
