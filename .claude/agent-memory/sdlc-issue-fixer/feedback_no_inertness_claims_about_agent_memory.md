---
name: no-inertness-claims-about-agent-memory
description: Never write "nothing loads it / nothing breaks" about a stale reference in .claude/agent-memory/ — check the owning agent's memory frontmatter and the installed plugin version first, then state the repair mechanism
metadata:
  type: feedback
---

# Don't call agent memory inert without checking who loads it

A `.claude/agent-memory/<agent>/` directory is auto-loaded into every
run of the agent it is named for, whenever that agent declares
`memory: project`. So "the reference is stale but nothing loads it,
nothing breaks" is a claim about a loading mechanism, not a throwaway
reassurance — and it is checkable in two greps: the agent's
frontmatter in `~/.claude/plugins/cache/thevoskamps/<plugin>/<ver>/
agents/`, and the installed version in
`~/.claude/plugins/installed_plugins.json`.

**Why:** PR #47's body claimed "nothing loads or resolves by section
number, so nothing breaks" about two stale `sdlc-pr-reviewer` entries.
Review disproved the claim. The right repair was to make the claim
true rather than smaller: separate *loading* (real — that is how the
entries are read at all) from *resolution* (nothing turns "§7" into a
file read, so no run errors), and name
`agent-memory-scrubber` — which runs last before `/pr-ready` — as the
mechanism that fixes the wording. See
[[agent-memory-is-tracked-repo-content]].

**How to apply:** when a change makes any agent-memory content stale
and you are explaining the impact in a PR body or commit message,
verify the load path before asserting impact. A directory named for an
agent the installed plugin version no longer ships is genuinely unread
— but say so as the version fact it is, not as a property of the
change, since a version bump can bring the agent back.
