<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.17.13

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.17.13** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

(a) A ${{ }} expression is placed directly inside the run script of the cache-meta step: `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Use $RUNNER_OS instead.

Locations:

- `action.yaml:13`

### script-injection (severity: high)

(b) In the install step, the env var ACTION_REF holds github.action_ref and is expanded without quotes: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. It should be quoted: "$ACTION_REF".

Locations:

- `action.yaml:30`

### script-injection (severity: high)

(a) A ${{ }} expression is placed directly inside the run script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass the value in through an env var instead.

Locations:

- `action.yaml:38`

### github-env-injection (severity: high)

The cache-meta step writes ACTION_REF (from github.action_ref) and runner.os to $GITHUB_OUTPUT without first running printf '%s' ... | tr -d '\n\r'. It also writes $HOME, an inherited env var, to $GITHUB_OUTPUT without sanitizing it.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

steps.cache-meta.outputs.path is written to $GITHUB_PATH without printf '%s' ... | tr -d '\n\r' sanitization: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`.

Locations:

- `action.yaml:38`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Changes in action.yaml: in the cache-meta step, `${{ runner.os }}` is now `$RUNNER_OS`. RUNNER_OS, ACTION_REF and HOME each go through `printf '%s' | tr -d '\n\r'` before being written to GITHUB_OUTPUT. In the install step, ACTION_REF is now quoted: `COMMIT="$(printf '%s' "$ACTION_REF" | cut -c1-7)"`. The PATH step now takes steps.cache-meta.outputs.path through an env var (ATLAS_BIN_PATH) and strips newlines from it before writing to GITHUB_PATH. github.action_ref is only used for the cache key and the build's COMMIT label, not to download anything from upstream, so I didn't swap it for upstream_ref. Nothing was run to test these changes.

