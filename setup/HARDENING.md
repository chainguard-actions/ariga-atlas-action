<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.17.12

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.17.12** was hardened automatically. 5 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): an expression is written straight into a run: script in step 'cache-meta': `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Pass runner.os in through env, or use $RUNNER_OS, instead.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

Step 'cache-meta' writes ACTION_REF (from github.action_ref) and runner.os to $GITHUB_OUTPUT with no `printf '%s' ... | tr -d '\n\r'` cleanup first: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`

### script-injection (severity: high)

Rule (b): ACTION_REF holds github.action_ref, which the caller controls, and the shell expands it without quotes: `run: make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote it as "$ACTION_REF".

Locations:

- `action.yaml:31`

### script-injection (severity: high)

Rule (a): an expression is written straight into a run: script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass it in through an env: variable and quote it.

Locations:

- `action.yaml:37`

### github-env-injection (severity: high)

A step output, steps.cache-meta.outputs.path, is written to $GITHUB_PATH with no `printf '%s' ... | tr -d '\n\r'` cleanup first: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:37`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Changes in action.yaml:
- Step 'cache-meta': runner.os now comes in through an env variable instead of being written into the script. The OS name, ACTION_REF and HOME each go through printf '%s' | tr -d '\n\r' before being written to GITHUB_OUTPUT.
- Make step: ACTION_REF is now quoted. The command is now COMMIT="$(printf '%s' "$ACTION_REF" | cut -c1-7)".
- PATH step: steps.cache-meta.outputs.path now comes in through the BIN_PATH env variable and has its newlines removed before it is added to GITHUB_PATH.

I kept github.action_ref even though it names the mirror's ref rather than upstream's, because here it only feeds the cache key and the COMMIT label for a local build. Nothing is downloaded from upstream with it.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Moved steps.cache-meta.outputs.path into env CACHE_PATH in the PATH-update step; sanitized with printf | tr -d '\n\r' before writing to $GITHUB_PATH.

