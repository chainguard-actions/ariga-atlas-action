<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.18.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.18.0** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the cache-meta step puts an expression straight into the run: script: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Use the env var instead: "$RUNNER_OS".

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

The cache-meta step writes ACTION_REF (from env, set to ${{ github.action_ref }}) to $GITHUB_OUTPUT without sanitizing it: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. The next line writes the inherited $HOME the same way. Run each value through `printf '%s' ... | tr -d '\n\r'` before the write.

Locations:

- `action.yaml:13`
- `action.yaml:14`

### script-injection (severity: high)

Rule (b): the make step expands ACTION_REF (from github.action_ref) without quotes: `run: make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote it as "$ACTION_REF", including the command substitution.

Locations:

- `action.yaml:30`

### script-injection (severity: high)

Rule (a): the PATH step puts an expression straight into the run: script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Move it into an env: variable and quote that variable.

Locations:

- `action.yaml:37`

### github-env-injection (severity: high)

The PATH step writes steps.cache-meta.outputs.path to $GITHUB_PATH without sanitizing it: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass the value through env and run it through `printf '%s' "$VAR" | tr -d '\n\r'` before the write.

Locations:

- `action.yaml:37`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

cache-meta step: replaced the ${{ runner.os }} expression with $RUNNER_OS. The key and path values now go through printf | tr -d '\n\r' before being written to GITHUB_OUTPUT. The cache key still uses ACTION_REF, as upstream did. make step: the COMMIT stamp now comes from a new ACTION_COMMIT env entry set to the upstream commit (a371755...), cut to 7 characters and fully quoted. Before, it was cut from the mirror's action_ref. PATH step: steps.cache-meta.outputs.path is now passed in through env (ATLAS_BIN_PATH) and has its newlines stripped before the write to GITHUB_PATH.

