<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.17.12

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.17.12** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the cache-meta step puts an expression directly inside the run script: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Use the $RUNNER_OS env var instead.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

The cache-meta step writes ACTION_REF (set from github.action_ref) and the inherited $HOME to $GITHUB_OUTPUT without the `printf '%s' ... | tr -d '\n\r'` cleanup step: `echo "key=...-$ACTION_REF" >> "$GITHUB_OUTPUT"` and `echo "path=$HOME/atlas-action" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`
- `action.yaml:14`

### script-injection (severity: high)

Rule (b): the env var ACTION_REF (from github.action_ref) is expanded without quotes inside a command substitution: `run: make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. It should be quoted, e.g. COMMIT="$(printf '%s' "$ACTION_REF" | cut -c1-7)".

Locations:

- `action.yaml:30`

### script-injection (severity: high)

Rule (a): the PATH step puts an expression directly inside the run script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass it through an env var and quote it.

Locations:

- `action.yaml:38`

### github-env-injection (severity: high)

The PATH step writes steps.cache-meta.outputs.path to $GITHUB_PATH without the `printf '%s' ... | tr -d '\n\r'` cleanup step: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

I fixed all five findings in action.yaml. Nothing was run or tested.

- **cache-meta step:** the `${{ runner.os }}` expression is gone from the script; it now uses `$RUNNER_OS`. The OS, `ACTION_REF` and `$HOME` values each have newlines stripped (`printf '%s' | tr -d '\n\r'`) before being written to `$GITHUB_OUTPUT`. The cache key still uses `ACTION_REF`, as upstream does.
- **make install step:** the value is now quoted: `COMMIT="$(printf '%s' "$ACTION_COMMIT" | cut -c1-7)"`. `ACTION_COMMIT` is a new env entry set to the upstream commit `be526fa360e6cb745546681470f4760dbbc49cf8`. Behaviour change: before, the short commit was cut from the ref, which on this mirror is a mirror commit or tag, not upstream's. The version stamp will now show upstream's short SHA.
- **PATH step:** `steps.cache-meta.outputs.path` now comes in through the `ATLAS_BIN_PATH` env var and has newlines stripped before being written to `$GITHUB_PATH`.

