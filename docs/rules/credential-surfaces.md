# Credential Surfaces Are User-Owned

Read this file when a command fails with an authentication error,
before you report that failure.

The user's credential agents — SSH agent, SSO token cache, GPG agent,
system keychain — belong to the user. Never, on your own initiative,
run a tool that inspects or manipulates their state.

## On auth failure

When a normal command fails with an auth error:

1. State the failure plainly.
2. If the failure is **expired or missing credentials** and the fix is
   a single command whose normal flow prompts the user for
   credentials, run that command and wait for the user to complete the
   prompt. If the user is slow to answer, keep waiting.
3. If the failure is **agent-state opaque** — e.g. SSH
   `Permission denied (publickey)` with no clear single-command fix —
   stop. Report it per "Reporting an auth failure" below, and wait
   for the user to deal with it. When told to retry, re-run the exact
   original command verbatim.
4. If the command from step 2 doesn't resolve the failure, stop and
   ask. Never reroute around the failure by switching remotes,
   swapping profiles, or retry-looping.

## Reporting an auth failure

The report for an auth failure has the following parts and nothing
else:

1. A bare statement that the operation failed.
2. The literal error output, verbatim, in a code block.
3. The question "What should I do?" (or equivalent).

Forbidden in that report:

- **Options and a recommendation.** No menu of what could be done
  next, and no pick among them. An auth report that would carry them
  anywhere else carries neither here.
- **Remediation.** No suggested commands, no `ssh-add`, no
  "try X". The fix is the user's.
- **Mechanism.** No explanation of why it failed, what
  `sign_and_send_pubkey` means, what the SSH handshake did, or
  which key was tried.
- **Unlabeled relay.** If the error text came from a subagent's
  report rather than a command you ran yourself, say so — "the
  subagent reported:" — and don't present it as something you
  observed. If the claim is load-bearing and cheaply checkable (did
  the push land? `git ls-remote`), check it against the live state
  yourself first.
