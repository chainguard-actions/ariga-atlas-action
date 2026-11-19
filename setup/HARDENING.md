<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.18.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.18.0** was hardened automatically. 5 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the expression is interpolated directly into the run script in step 'cache-meta': `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Fix: use the $RUNNER_OS env var instead.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

Step 'cache-meta' writes ACTION_REF to $GITHUB_OUTPUT without the printf '%s' | tr -d '\n\r' step: `echo "key=...-$ACTION_REF" >> "$GITHUB_OUTPUT"`. ACTION_REF comes from github.action_ref.

Locations:

- `action.yaml:13`

### script-injection (severity: high)

Rule (b): the variable is expanded without quotes: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. ACTION_REF comes from github.action_ref and must be double-quoted.

Locations:

- `action.yaml:31`

### script-injection (severity: high)

Rule (a): the expression is interpolated directly into the run script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:38`

### github-env-injection (severity: high)

steps.cache-meta.outputs.path is written to $GITHUB_PATH without the printf '%s' | tr -d '\n\r' step: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

I fixed all five findings in action.yaml.

- **cache-meta step:** the script now reads the `$RUNNER_OS` environment variable instead of the inline `${{ runner.os }}` expression. Line breaks are removed from both that value and ACTION_REF before the key is written to $GITHUB_OUTPUT.
- **make install step:** the short commit stamped into the build now comes from a new `ACTION_COMMIT` env entry set to upstream's commit (a371755a870cce768818e0047d7fdef5ead98713). It is cut to 7 characters with quoting: `COMMIT="$(printf '%s' "$ACTION_COMMIT" | cut -c1-7)"`. The original ACTION_REF read the mirror's ref, which would have stamped a commit upstream never published. ACTION_REF is still set in that step's env as before, and the cache key still uses it, as upstream does.
- **PATH step:** `steps.cache-meta.outputs.path` now comes in through a `BIN_PATH` env var. Line breaks are removed from it before it is written to $GITHUB_PATH.

I haven't run the action, so none of this is tested.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

cache-meta step: strip newlines from $HOME (safe_home) before writing path output to $GITHUB_OUTPUT.

