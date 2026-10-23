# Credential Surfaces Are User-Owned

Read this file when a command fails with an authentication error,
before you report that failure.

The user's credential agents — SSH agent, SSO token cache, GPG agent,
system keychain — belong to the user. Never, on your own initiative,
run a tool that inspects or manipulates their state.

## On auth failure

When a normal command fails with an auth error:

1. State the failure plainly.
2. If the failure is an **expired AWS SSO session**, run
   `aws sso login` for the same profile and wait for the user to
   complete the prompt. If the user is slow to answer, keep waiting.
3. Every other auth failure — another CLI's login, an agent-state
   opaque failure such as SSH `Permission denied (publickey)`, a
   missing scope, role, or permission — stop. Report it and wait for
   the user to deal with it. Never remediate a missing scope, role,
   or permission yourself, not even with a command the error message
   suggests. When told to retry, re-run the exact original command
   verbatim.
4. If `aws sso login` doesn't resolve the failure, stop and ask.
   Never reroute around the failure by switching remotes, swapping
   profiles, or retry-looping.

## Reporting an auth failure

Forbidden in an auth-failure report:

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
