<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.17.13

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.17.13** was hardened automatically. 5 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

(a) Direct expression interpolation in run block (cache-meta step): `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Use $RUNNER_OS instead.

Locations:

- `action.yaml:13`

### script-injection (severity: high)

(b) Unquoted expansion of workflow-controlled env var in run block: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. $ACTION_REF (from github.action_ref) must be double-quoted.

Locations:

- `action.yaml:30`

### script-injection (severity: high)

(a) Direct expression interpolation in run block: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass the value through an env: variable and double-quote it.

Locations:

- `action.yaml:38`

### github-env-injection (severity: high)

cache-meta step writes ACTION_REF (from github.action_ref) to $GITHUB_OUTPUT without the `printf '%s' ... | tr -d '\n\r'` sanitization step: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

This step writes steps.cache-meta.outputs.path to $GITHUB_PATH without sanitization: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Apply `printf '%s' "$VAR" | tr -d '\n\r'` before the write.

Locations:

- `action.yaml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

cache-meta: replaced ${{ runner.os }} with $RUNNER_OS; sanitized ACTION_REF and RUNNER_OS with tr -d '\n\r' before writing to GITHUB_OUTPUT. make step: quoted ACTION_REF via printf '%s' "$ACTION_REF" | cut -c1-7 inside a quoted command substitution. PATH step: moved steps.cache-meta.outputs.path into env ATLAS_BIN_PATH, sanitized newlines before writing to GITHUB_PATH.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

In action.yaml step 'cache-meta', $HOME is now sanitized with printf '%s' | tr -d '\n\r' into safe_home before 'path=${safe_home}/atlas-action' is written to $GITHUB_OUTPUT. When HOME contains no newline, the result is the same as before.

