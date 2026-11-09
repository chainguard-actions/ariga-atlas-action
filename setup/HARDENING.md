<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.17.12

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.17.12** was hardened automatically. 5 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the cache-meta step puts an expression straight into a run: script: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Pass it in through env instead (e.g. use $RUNNER_OS).

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

The cache-meta step writes ACTION_REF (from github.action_ref) to $GITHUB_OUTPUT without first running printf '%s' ... | tr -d '\n\r' on it: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`

### script-injection (severity: high)

Rule (b): the make install step expands the env var ACTION_REF (from github.action_ref) without quotes: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote it as "$ACTION_REF" and quote the command substitution too.

Locations:

- `action.yaml:30`

### script-injection (severity: high)

Rule (a): the PATH step puts an expression straight into a run: script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass it in through an env var instead.

Locations:

- `action.yaml:38`

### github-env-injection (severity: high)

The PATH step writes steps.cache-meta.outputs.path to $GITHUB_PATH without first running printf '%s' ... | tr -d '\n\r' on it: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

I fixed all five findings in action.yaml. I did not run the action afterwards to confirm it still works.

- **Cache-meta step:** `runner.os` and the action ref now come in through env vars instead of being written straight into the script. The step strips newlines from both before writing the cache key to GITHUB_OUTPUT.
- **make install step:** the COMMIT value is now quoted. It is cut from the upstream commit (be526fa…, added as a new `ACTION_COMMIT` env var) instead of the mirror's `github.action_ref`. Without that change the build would be stamped with a mirror commit or tag rather than upstream's short SHA. `ACTION_REF` is still set on that step, just no longer read there.
- **PATH step:** the binary path now comes in through an env var and has newlines stripped before it is written to GITHUB_PATH.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

In the cache-meta step of action.yaml, $HOME is now sanitized into safe_home with printf '%s' | tr -d '\n\r' before path=${safe_home}/atlas-action is written to $GITHUB_OUTPUT.

