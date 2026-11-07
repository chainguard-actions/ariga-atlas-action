<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.17.13

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.17.13** was hardened automatically. 5 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

(a) Expression interpolated directly in a run: block of step 'cache-meta': `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Pass runner.os through env (e.g. use "$RUNNER_OS") instead.

Locations:

- `action.yaml:13`

### script-injection (severity: high)

(b) Unquoted expansion of the workflow-controlled env var ACTION_REF (from github.action_ref): `run: make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote it as "$ACTION_REF".

Locations:

- `action.yaml:30`

### script-injection (severity: high)

(a) Expression interpolated directly in a run: block: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Route the value through an env: variable and quote it.

Locations:

- `action.yaml:37`

### github-env-injection (severity: high)

Step 'cache-meta' writes untrusted values to $GITHUB_OUTPUT without the printf '%s' ... | tr -d '\n\r' sanitization step. The values are ACTION_REF (from github.action_ref) and runner.os in `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`, plus the inherited $HOME in `echo "path=$HOME/atlas-action" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`
- `action.yaml:14`

### github-env-injection (severity: high)

steps.cache-meta.outputs.path is written to $GITHUB_PATH without sanitization: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass it through printf '%s' "$VAR" | tr -d '\n\r' before the write.

Locations:

- `action.yaml:37`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Changes to action.yaml: (1) In the cache-meta step, runner.os now goes through env (RUNNER_OS_NAME). The key and path values pass through printf '%s' | tr -d '\n\r' before they are written to GITHUB_OUTPUT. (2) The make step now quotes ACTION_REF inside the COMMIT command substitution, which uses printf instead of echo. (3) The GITHUB_PATH step reads steps.cache-meta.outputs.path from env (BIN_PATH) and strips newlines before writing it. I kept github.action_ref as it was: it only sets the cache key and the COMMIT value for a local build, and nothing fetches from upstream with it.

### Iteration 2

**Fixes applied:** invalid-yaml

**Notes:**

The file is action.yaml, not action.yml as the finding says. An earlier pass broke it: lines from the build step (make install) and the step that writes the binary path to $GITHUB_PATH were run together, with lines lost, lines duplicated and a stray value ('...outputs.path }}ATH"'). I rebuilt that section. The build step got back its env block with ACTION_REF: ${{ github.action_ref }}, which its COMMIT="$(printf '%s' "$ACTION_REF" | cut -c1-7)" line uses. The PATH step is now its own 'run: |' block: it strips newlines from BIN_PATH before writing it to $GITHUB_PATH, sets ATLAS_ACTION_LOCAL=1 in $GITHUB_ENV, and maps BIN_PATH from steps.cache-meta.outputs.path. I removed the duplicated lines. GOBIN is my guess: I set GOBIN: ${{ steps.cache-meta.outputs.path }} on the build step, but the broken file did not show it and the Makefile was not available to confirm it. The cache step saves $HOME/atlas-action and the next step puts that folder on PATH, which only works if make install puts the binary there, and GOBIN is what does that. Compare this step with upstream v1.17.13. github.action_ref is still the mirror's ref and was left alone: here it only feeds the cache key and the short commit label passed to make, not a download from upstream.

