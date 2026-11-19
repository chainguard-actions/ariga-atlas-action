<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.18.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.18.1** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the cache-meta step puts a GitHub expression straight into the run script: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Pass runner.os in through an env var such as "$RUNNER_OS" instead.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

The cache-meta step writes ACTION_REF (from github.action_ref) and the inherited $HOME to $GITHUB_OUTPUT without first running printf '%s' ... | tr -d '\n\r': `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"` and `echo "path=$HOME/atlas-action" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`
- `action.yaml:14`

### script-injection (severity: high)

Rule (b): the build step expands ACTION_REF (from github.action_ref) without quotes: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote both the variable and the command substitution, e.g. COMMIT="$(printf '%s' "$ACTION_REF" | cut -c1-7)".

Locations:

- `action.yaml:31`

### script-injection (severity: high)

Rule (a): the PATH step puts a GitHub expression straight into the run script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass it in through an env var instead.

Locations:

- `action.yaml:39`

### github-env-injection (severity: high)

The PATH step writes steps.cache-meta.outputs.path to $GITHUB_PATH without first running printf '%s' ... | tr -d '\n\r': `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:39`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

action.yaml: moved runner.os and steps.cache-meta.outputs.path into env vars. Values written to GITHUB_OUTPUT/GITHUB_PATH now have newlines stripped with printf | tr -d '\n\r'. The build step's COMMIT is now quoted and comes from a new ACTION_COMMIT env set to the upstream commit (58daf85…), cut to 7 characters. On the mirror, github.action_ref is not upstream's ref, which is why the commit is hardcoded. ACTION_REF is kept for the cache key, as upstream had it.

