<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.17.13

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.17.13** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a), step cache-meta: the run block puts a template expression straight into the shell command: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Use the $RUNNER_OS env var instead.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

Step cache-meta writes ACTION_REF (set from github.action_ref) to $GITHUB_OUTPUT without running `printf '%s' ... | tr -d '\n\r'` first: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. On the next line it writes the inherited $HOME without sanitising it either: `echo "path=$HOME/atlas-action" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yaml:13`
- `action.yaml:14`

### script-injection (severity: high)

Sub-rule (b), make install step: the env var ACTION_REF (from github.action_ref) is expanded without quotes: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote it as "$ACTION_REF" and quote the command substitution too.

Locations:

- `action.yaml:31`

### script-injection (severity: high)

Sub-rule (a), PATH setup step: the run block puts a template expression straight into the shell command: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass the value through an env: variable and quote it where the shell expands it.

Locations:

- `action.yaml:38`

### github-env-injection (severity: high)

PATH setup step writes steps.cache-meta.outputs.path to $GITHUB_PATH without running `printf '%s' ... | tr -d '\n\r'` first: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

cache-meta: uses $RUNNER_OS instead of ${{ runner.os }}; key/path sanitized with printf|tr -d '\n\r' before writing to GITHUB_OUTPUT. make install: COMMIT now derived from the upstream commit (ACTION_COMMIT env = fc91f650...) cut to 7 chars, fully quoted, since the mirror's action_ref would stamp a wrong value; ACTION_REF kept for cache key. PATH step: steps.cache-meta.outputs.path moved to env ATLAS_BIN_PATH, sanitized before writing to GITHUB_PATH.

