<!-- markdownlint-disable -->

# Hardening Report: ariga--atlas-action--setup/v1.18.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **ariga--atlas-action--setup/v1.18.1** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the expression ${{ runner.os }} is placed straight into the run: script of step 'cache-meta': `echo "key=${{ runner.os }}-atlas-action-$ACTION_REF" >> "$GITHUB_OUTPUT"`. Use the $RUNNER_OS env var instead.

Locations:

- `action.yaml:13`

### github-env-injection (severity: high)

Step 'cache-meta' writes ACTION_REF (set from github.action_ref) and runner.os into $GITHUB_OUTPUT without first running `printf '%s' ... | tr -d '\n\r'` on the value.

Locations:

- `action.yaml:13`

### script-injection (severity: high)

Rule (b): ACTION_REF (from github.action_ref) is expanded without quotes: `make -C .. install COMMIT=$(echo $ACTION_REF | cut -c1-7)`. Quote it as "$ACTION_REF".

Locations:

- `action.yaml:30`

### script-injection (severity: high)

Rule (a): the expression ${{ steps.cache-meta.outputs.path }} is placed straight into a run: script: `echo "${{ steps.cache-meta.outputs.path }}" >> "$GITHUB_PATH"`. Pass it through an env: variable instead.

Locations:

- `action.yaml:37`

### github-env-injection (severity: high)

A step output (steps.cache-meta.outputs.path) is written to $GITHUB_PATH without first running `printf '%s' ... | tr -d '\n\r'` on the value.

Locations:

- `action.yaml:37`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

I fixed all five findings in action.yaml.
- **cache-meta step:** it now reads the runner OS from $RUNNER_OS instead of an inline ${{ runner.os }} expression. The OS, ACTION_REF and HOME values each go through printf | tr -d '\n\r' before being written to GITHUB_OUTPUT. The cache key still uses the action ref, as upstream does.
- **make install step:** this step used to take the first 7 characters of github.action_ref (unquoted) as COMMIT. That ref belongs to the mirror, not upstream, so this step now reads ACTION_COMMIT, set to the upstream commit 58daf85fd2cb9f88a46c42d8a40083d68c0e03cf. It is quoted and cut the same way: COMMIT="$(printf '%s' "$ACTION_COMMIT" | cut -c1-7)". As a result the build is stamped with upstream's short SHA rather than the mirror's. ACTION_REF was only used for COMMIT, so I removed it from this step's env.
- **PATH step:** steps.cache-meta.outputs.path now arrives through a CACHE_PATH env var, and newlines are stripped before it is written to GITHUB_PATH.

I haven't run the action or re-run the analysis to confirm these findings now clear.

