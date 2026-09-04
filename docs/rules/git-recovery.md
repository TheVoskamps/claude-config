# Git Recovery

Read this file when one of its named errors appears, or when a merge
is requested. These are rare-event procedures, not everyday judgment.

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

## Dropping a commit from a branch

`git reset --hard` and a detach-plus-`git branch -f` move are both
refused in a subagent worktree, the first as forbidden outright. Drop
the commit with `git reset --soft HEAD~1`, discard what it introduced
with `git restore --source=HEAD --staged --worktree PATHS`, and
publish with `git push --force-with-lease --force-if-includes`. The
soft reset holds every change in the index until you name the paths to
discard, so nothing goes silently.

## Running git in a worktree-isolated subagent

A `git` command joined to anything with `&&`, or fed its message on
stdin from a heredoc, is refused with "names git in a form too complex
to verify that it stays inside the worktree". The gate proves
statically that the command targets the agent's own worktree, so it is
not a permission prompt and there is no approving past it — run every
`git` invocation as its own bare Bash call instead.

For a commit message too long to pass as `-m`, write it to a file
first and commit with `git commit -F PATH`; `gh pr create` takes
`--body-file` the same way.
