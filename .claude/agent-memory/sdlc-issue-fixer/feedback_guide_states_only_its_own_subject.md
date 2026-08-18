---
name: guide-states-only-its-own-subject
description: In claude-config rules files, off-subject mechanics get deleted rather than reworded — a repeatedly-rewritten paragraph is a signal the subject is wrong, not the wording
metadata:
  type: feedback
---

# A guide states only its own subject

When a paragraph in a rules file explains mechanics that belong to a
different subject, cut the paragraph. Do not rewrite it more carefully.

**Why:** the owner ruled this on PR 50, where the per-repo extension
sections of `rules/code-style.md` and `rules/comment-style.md` each
carried a paragraph on git's ignore-negation semantics. It had been
rewritten in four consecutive review rounds and was still wrong. The
owner's reasoning: a code/comment style guide has no business
explaining how `.gitignore` resolves, and a reader who needs that
answer gets it from `git check-ignore`.

**How to apply:** a paragraph that a review has corrected more than
once is evidence the material does not belong in the file at all —
treat the repeat correction as the trigger to re-examine scope rather
than to attempt a more precise wording. Keep the part that is the
file's own subject (here: the fixed extension filename, the sibling
guide's filename, the resolution order) and delete the rest. Related:
[[no-stub-after-moving-a-rule]],
[[shared-contract-stated-once-not-stubbed]].
