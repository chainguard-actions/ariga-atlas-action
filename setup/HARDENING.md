<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.17.12

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.17.12** was hardened automatically. 5 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

(a) Step 'cache-meta' puts an expression straight into the run script: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Use $RUNNER_OS instead.

Locations:

- `action.yaml:13`

### script-injection (severity: high)

(b) In the build step, an env var from github.action_ref is expanded without quotes inside command substitution: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote it as "$ACTION_REF" and quote the whole COMMIT value.

Locations:

- `action.yaml:31`

### script-injection (severity: high)

(a) The PATH step puts an expression straight into the run script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass it through an env: variable and quote it.

Locations:

- `action.yaml:38`

### github-env-injection (severity: high)

Step 'cache-meta' writes untrusted values to $GITHUB_OUTPUT without the `printf '%s' ... | tr -d '\n\r'` sanitization: ACTION_REF (from github.action_ref) and runner.os on line 13, and the inherited $HOME on line 14.

Locations:

- `action.yaml:13`
- `action.yaml:14`

### github-env-injection (severity: high)

The PATH step writes steps.cache-meta.outputs.path to $GITHUB_PATH without sanitization: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

cache-meta step: now uses $RUNNER_OS instead of ${{ runner.os }}, and the key and path values are cleaned with printf | tr -d '\n\r' before they are written to GITHUB_OUTPUT. Build step: ACTION_REF is now quoted and the whole COMMIT value is quoted. PATH step: the steps.cache-meta.outputs.path value now comes in through the env var ATLAS_BIN_PATH, and newlines are stripped before it is written to GITHUB_PATH.

### Iteration 2

**Fixes applied:** github-env-injection, invalid-yaml

**Notes:**

In action.yaml, the line that cleans the PATH value was stuck onto the end of a comment, so it never ran. I put `safe_bin_path=$(printf '%s' "$ATLAS_BIN_PATH" | tr -d '\n\r')` back on its own line, so the value has newlines removed before it goes into $GITHUB_PATH. I also took `shell: bash` off the end of the ATLAS_BIN_PATH env line. That leftover text was what broke the YAML. Nothing else in the file changed. The first targeted edit said it succeeded but didn't stick, so I rewrote the whole file with the same content apart from these two fixes. A search afterwards confirmed both problems are gone.

