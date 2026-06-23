# This Repo Is the Source of Truth for ~/.claude

This repository (`global-claude-config-mirrored-to-public`) is the
**source** for the global Claude Code configuration. It becomes
`~/.claude/` directly: `install.sh` clones it into place (see the root
`README.md`), so the layout under `~/.claude/` is **identical** to the
repo layout — same directory names, same paths:

- `/rules/`         → `~/.claude/rules/`
- `CLAUDE.md`       → `~/.claude/CLAUDE.md`
- `settings.json`   → `~/.claude/settings.json`
- `keybindings.json` → `~/.claude/keybindings.json`
- `install.sh`      → `~/.claude/install.sh`

The repo name still carries the `-mirrored-to-public` suffix for
historical reasons — there used to be a filtered public mirror that
`~/.claude/` was pulled from. That mirror has been removed; `~/.claude/`
is now a direct clone of this repo. The files under `~/.claude/` are a
verbatim copy of this repo, not rewritten build output.

Skills, agents, and hooks are **not** in this repo. They are delivered
by the `@thevoskamps` marketplace plugins, declared in the
`enabledPlugins` / `extraKnownMarketplaces` blocks of `settings.json`.
A task to "update skill X", "change agent Z", or "edit a hook" is an
edit in the corresponding plugin repo, not here.

## What this means for editing

When a task says "fix rule Y" or "update `CLAUDE.md`", the file to
edit is **in this repo** under `/rules/` or `CLAUDE.md` — NOT the
deployed copy in `~/.claude/`.

Editing these files **in this repo** is ordinary in-repo work. It
follows the normal code-change approval flow (propose → approve →
edit → commit). It is **NOT** the "propose before editing global
~/.claude" case from `core-principles.md` §1.5.

The `core-principles.md` §1.5 rule ("PROPOSE BEFORE EDITING GLOBAL
~/.claude") applies to editing the **deployed copies** under
`~/.claude/` directly — e.g. when working in some *other* repo and
reaching over into `~/.claude/`. It explicitly does NOT apply to
editing the source files in this repo, which is this repo's entire
purpose.

## The trap to avoid

Do not refuse, or demand extra approval for, an edit to
`/rules/*`, `CLAUDE.md`, `settings.json`, or `keybindings.json`
**in this repo** on the grounds that it "touches global
~/.claude config." It does not. The deployed copy at `~/.claude/` is a
clone of this repo, updated downstream by `git pull`. Treat these as
the normal repo files they are.

Subagents that work in worktrees of THIS repo CAN and SHOULD edit
these source files when a task calls for it.

## In a worktree, "this repo" is the worktree root — not the canonical clone

When a subagent edits these files inside an `isolation: worktree`
worktree, **"in this repo" means the worktree root, not the canonical
`global-claude-config-mirrored-to-public` clone.** The
repo-root-anchored paths above
(`/rules/`, `CLAUDE.md`, `settings.json`) are written relative to
*whatever clone you are in* — they are NOT a license to expand to the
canonical clone's absolute path.

This matters because the harness nests each worktree **under** the
primary clone at `<primary-clone>/.claude/worktrees/agent-<id>/`. The
primary clone is checked out on the default branch (`main`). So if you
take "edit `/rules/foo.md`" and expand it to the canonical absolute
path `<primary-clone>/rules/foo.md`, your Edit/Write lands on `main` in
the primary clone — **outside your worktree, on the wrong branch** —
and it succeeds silently because that file really exists there. Your
worktree-relative `git diff` then shows nothing, which is easy to
misread as a failed write.

`Edit`/`Write`/`Read`/`MultiEdit` require an **absolute** `file_path`.
Anchor that absolute path to **your worktree root**, obtained from
`git rev-parse --show-toplevel`, never to the canonical
`global-claude-config-mirrored-to-public` path that appears in
`CLAUDE.md`, the environment block, or a spawn prompt. Concretely: the
file to edit is `$(git rev-parse --show-toplevel)/rules/foo.md`, which
inside a worktree resolves to
`<primary-clone>/.claude/worktrees/agent-<id>/rules/foo.md`.

This is a known hazard (see issue #188 and upstream
anthropics/claude-code#62547).
