<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.18.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.18.2** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the cache-meta step puts a GitHub Actions expression straight into the run script: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Pass runner.os through env, or use $RUNNER_OS, instead of templating it into the script.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

The cache-meta step writes ACTION_REF (from github.action_ref) and the inherited $HOME to $GITHUB_OUTPUT without first running printf '%s' ... | tr -d '\n\r': `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"` and `echo "path=$HOME/atlas-action" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`
- `action.yaml:14`

### script-injection (severity: high)

Rule (b): the build step expands the env var ACTION_REF (from github.action_ref) unquoted inside a command substitution: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote it as "$ACTION_REF", and quote the whole COMMIT value.

Locations:

- `action.yaml:30`

### script-injection (severity: high)

Rule (a): the PATH step puts a GitHub Actions expression straight into the run script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass it through an env var and quote it.

Locations:

- `action.yaml:37`

### github-env-injection (severity: high)

The PATH step writes steps.cache-meta.outputs.path to $GITHUB_PATH without first running printf '%s' ... | tr -d '\n\r': `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:37`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

In action.yaml: moved runner.os into env (RUNNER_OS_NAME), and the cache-meta step now strips newlines from the OS, ACTION_REF and HOME before writing to GITHUB_OUTPUT. The build step now quotes the COMMIT value. It also takes the commit from ACTION_COMMIT, set to upstream_commit c67b7be..., instead of from the mirror's action_ref, so the version stamp matches upstream. ACTION_REF is kept for the cache key. The PATH step reads the path from an env var (ATLAS_BIN_PATH) and strips newlines before writing it to GITHUB_PATH.

