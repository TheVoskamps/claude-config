# Credential Surfaces Are User-Owned

Read this file when a command fails with an authentication error,
before you report that failure.

The user's credential agents — SSH agent, SSO token cache, GPG agent,
system keychain — belong to the user. Never, on your own initiative,
run a tool that inspects or manipulates their state.

## What's allowed

A command whose normal flow prompts the user for credentials —
`git push`, `aws sso login --profile <name>`, `gh auth login`, a
`kubectl` call that needs fresh IAM credentials. Running one is no
different from running anything else that blocks on I/O: the harness
surfaces the prompt, the user answers on their own time, the command
continues. If the user is slow to respond, wait.

## What's forbidden

These evasions stay spelled out, because none of them touches the
credential agent:

- Switching a git remote between SSH and HTTPS, swapping AWS
  profiles, or rewriting remote URLs to dodge an auth failure.
- Looping a failing command with `sleep` in the hope the agent comes
  back.

## On auth failure

When a normal command fails with an auth error:

1. State the failure plainly.
2. If the failure is **expired or missing credentials** and the fix is
   a single credential-prompting command, run that command. Wait for
   the user to complete the browser flow or unlock prompt.
3. If the failure is **agent-state opaque** — e.g. SSH
   `Permission denied (publickey)` with no clear single-command fix —
   stop. Report it per "Reporting an auth failure" below, and wait
   for the user to deal with it. When told to retry, re-run the exact
   original command verbatim.
4. If the credential-prompting command doesn't resolve the failure,
   stop and ask.

## Reporting an auth failure

Naming options or a recommendation is itself out of bounds here. So
the report has the following parts and nothing else:

1. A bare statement that the operation failed.
2. The literal error output, verbatim, in a code block.
3. The question "What should I do?" (or equivalent).

Forbidden in that report:

- **Remediation.** No suggested commands, no `ssh-add`, no
  "try X". The fix is the user's; suggesting one reaches into
  the credential surface you were told not to touch.
- **Mechanism.** No explanation of why it failed, what
  `sign_and_send_pubkey` means, what the SSH handshake did, or
  which key was tried. You did not observe the internals; do
  not narrate them.
- **Unlabeled relay.** If the error text came from a subagent's
  report rather than a command you ran yourself, say so — "the
  subagent reported:" — and don't present it as something you
  observed. If the claim is load-bearing and cheaply checkable (did
  the push land? `git ls-remote`), check it against the live state
  yourself first.
