<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.18.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.18.3** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): a GitHub Actions expression is placed directly inside a run: script in step 'cache-meta': `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Fix: pass runner.os in through env, or use $RUNNER_OS.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

Step 'cache-meta' writes ACTION_REF (from github.action_ref) and runner.os to $GITHUB_OUTPUT without first running `printf '%s' ... | tr -d '\n\r'`: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`

### script-injection (severity: high)

Rule (b): the env var ACTION_REF (from github.action_ref) is expanded without quotes inside a command substitution: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote it as "$ACTION_REF".

Locations:

- `action.yaml:31`

### script-injection (severity: high)

Rule (a): an expression is placed directly inside a run: script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass it in through env and quote the variable.

Locations:

- `action.yaml:38`

### github-env-injection (severity: high)

A step output (steps.cache-meta.outputs.path) is written to $GITHUB_PATH without first running `printf '%s' ... | tr -d '\n\r'`: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

I fixed all five findings in action.yaml.
- cache-meta step: the script now reads $RUNNER_OS from the environment instead of the inline runner.os expression. RUNNER_OS, ACTION_REF and HOME each have newlines stripped before being written to GITHUB_OUTPUT. The cache key still uses the ref, as upstream does.
- make install step: COMMIT is now cut from a fixed ACTION_COMMIT env value (the upstream commit 31da118) instead of from the mirror's github.action_ref, and the expansion is quoted. The build now stamps upstream's short SHA rather than one taken from a mirror ref.
- PATH step: steps.cache-meta.outputs.path is passed in through env (BIN_PATH), and newlines are stripped before it is written to GITHUB_PATH.

