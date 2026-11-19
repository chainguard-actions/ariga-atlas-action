<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.17.13

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.17.13** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): step 'cache-meta' puts an expression straight into the run script: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Fix: map runner.os to an env var, or use the existing $RUNNER_OS variable, and quote it.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

Step 'cache-meta' writes ACTION_REF (from github.action_ref) and the inherited $HOME to $GITHUB_OUTPUT without first running `printf '%s' ... | tr -d '\n\r'`: `echo "key=...-$ACTION_REF" >> "$GITHUB_OUTPUT"` and `echo "path=$HOME/atlas-action" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`
- `action.yaml:14`

### script-injection (severity: high)

Rule (b): the build step expands an env var holding github.action_ref without quotes: `run: make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Fix: quote both the variable and the command substitution, e.g. COMMIT="$(printf '%s' "$ACTION_REF" | cut -c1-7)".

Locations:

- `action.yaml:31`

### script-injection (severity: high)

Rule (a): the PATH step puts an expression straight into the run script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Fix: pass it through an env var and quote it.

Locations:

- `action.yaml:38`

### github-env-injection (severity: high)

The PATH step writes steps.cache-meta.outputs.path to $GITHUB_PATH without first running `printf '%s' ... | tr -d '\n\r'`.

Locations:

- `action.yaml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed all five findings in action.yaml.
- cache-meta step: runner.os now comes in through an env var (RUNNER_OS_NAME) instead of being inlined in the script. RUNNER_OS_NAME, ACTION_REF and HOME have newlines stripped with printf | tr -d '\n\r' before they are written to GITHUB_OUTPUT.
- Build step: COMMIT is now quoted and set from a new ACTION_COMMIT env var, which holds the upstream commit fc91f650… cut to 7 characters. This follows the mirror rule: the mirror's own ref would stamp the wrong version. ACTION_REF is still used in the cache key, as upstream had it.
- PATH step: steps.cache-meta.outputs.path now comes in through an env var (ATLAS_BIN_PATH) and has newlines stripped before it is written to GITHUB_PATH.

