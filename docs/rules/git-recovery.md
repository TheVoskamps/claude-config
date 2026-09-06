# Git Recovery

Read this file when one of its named errors appears, when a rebase
stops on a conflict, when a merge is requested, or when a git command
is refused for its shape rather than for what it would do. These are
rare-event procedures, not everyday judgment.

## Commit signing

If you get an error on a commit "remote: error: GH006: Protected branch
update failed for refs/heads/main." or "remote: error: Commits must have
verified signatures." or "remote: error: GH013: Repository rule violations
found for refs/heads/main." or "remote: - Commits must have verified
signatures." you need to sign the commit with a signature GitHub can
verify (GPG, S/MIME, or SSH) against a key registered to a GitHub account,
with the committer email matching a verified email on that account.

## Merging

Dry-run the merge first:
`git checkout TARGET_BRANCH && git merge --no-commit --no-ff main`.

Don't squash merge, and don't merge the default branch into another
branch — rebase the other branch onto it instead.

## Recovering a commit made on the wrong branch

1. `git stash` — save working changes.
2. `git reset --soft HEAD~1` — undo the commit, keeping what it
   introduced staged.
3. `git checkout CORRECT_BRANCH` — the staged changes come with you.
4. `git commit` — commit to the correct branch.
5. `git stash pop` — re-apply the saved changes.

## Committing a message too long for `-m`

In a subagent worktree, write the message to a file under
`.claude/tmp/` and commit with a plain `git commit -F FILE`, one git
verb per Bash call. A heredoc piped into `git commit`, and `git add`,
`git commit`, and `git log` chained with `&&`, are both refused by the
worktree-isolation gate, which cannot statically verify such a command
stays inside the worktree. `.claude/tmp/` is gitignored, so the message
file never lands in the commit.

## Dropping a commit from a branch

`git reset --hard` and a detach-plus-`git branch -f` move are both
refused in a subagent worktree, the first as forbidden outright. Drop
the commit with `git reset --soft HEAD~1`, discard what it introduced
with `git restore --source=HEAD --staged --worktree PATHS`, and
publish with `git push --force-with-lease --force-if-includes`. The
soft reset holds every change in the index until you name the paths to
discard, so nothing goes silently.

## Finishing a conflicted rebase

Commit the resolution yourself, then let the rebase walk on:

```bash
git add RESOLVED_PATHS
git commit --no-edit          # lands the resumed commit with its original message
git rebase --continue         # finds nothing to commit, continues without an editor
```

Neither `GIT_EDITOR=true git rebase --continue` nor
`git rebase --continue --no-edit` works: the first is rejected for its
inline environment-assignment prefix and the second names a flag
`rebase` does not accept. That prefix rejection comes from the
permission gate, not from git, so it constrains nothing else about
`git rebase`.
