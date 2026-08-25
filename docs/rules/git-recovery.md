# Git Recovery

Read this file when one of its named errors appears, or when a merge
is requested. These are rare-event procedures, not everyday judgment —
`rules/git-workflow.md` covers the everyday commit/push rules.

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
2. `git reset --hard HEAD~1` — undo the commit on the wrong branch.
3. `git checkout CORRECT_BRANCH`.
4. `git stash pop` — re-apply the saved changes.
5. `git commit` — commit to the correct branch.
