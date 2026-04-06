# Sentinel CI Troubleshooting Guide

Use this page when Sentinel CI is installed but not behaving as expected.

## Start Here (2-Minute Triage)

1. Confirm workflow permissions include `contents: read` and `pull-requests: write`
2. Confirm `.sentinel-ci.yml` exists at repository root
3. Confirm action inputs are valid in `.github/workflows/sentinel-ci.yml`
4. Confirm optional secrets exist if AI output is expected
5. Confirm blocking severities are intentionally strict

## Symptom to Fix (Fast Path)

| Symptom | Most likely cause | Fastest fix |
|---------|-------------------|-------------|
| No PR comment | Missing permissions or wrong trigger | Add `pull-requests: write` and use `pull_request` trigger |
| AI output missing | Secrets not passed as env vars | Add at least one provider secret and map it in workflow `env` |
| CodeQL not running | CodeQL disabled or languages not detected | Set `enable_codeql: "true"` and explicit `codeql_languages` |
| CI blocking unexpectedly | Strict severity thresholds | Reduce `block_on_severity` temporarily to tune findings |
| Config ignored | Wrong file path/name | Use `.sentinel-ci.yml` at repo root |

## 1. No PR comment is posted

Check:

1. The workflow runs on a pull request event
2. Workflow permissions include `pull-requests: write`
3. `github_token` is set correctly
4. The repository is not blocking token access for forked PRs

Quick fix:

- Re-run the workflow after confirming permissions and trigger event type

## 2. The action fails with exit code 1

This usually means Sentinel CI found blocking issues.

Check:

1. `security.block_on_severity`
2. `codeql.block_on_severity`
3. `hooks.pre_push.block_on_severity`
4. `block_on_findings` is not set to `"false"`

Quick fix:

- Lower blocking strictness temporarily while tuning findings

## 3. CodeQL does not run

Check:

1. `enable_codeql: "true"` in workflow or `codeql.enabled: true` in config
2. The repo contains a supported language
3. `codeql_languages` is set explicitly for large or unusual repos
4. Workflow runtime is long enough for CodeQL database creation

Quick fix:

- Set explicit `codeql_languages` for deterministic behavior

## 4. No supported languages detected for CodeQL analysis

Fix:

1. Set workflow input `codeql_languages`
2. Or set `codeql.languages` in `.sentinel-ci.yml`

Example:

```yaml
codeql:
  enabled: true
  languages: [python, typescript]
```

## 5. AI explanations are missing

Check:

1. One of these secrets is configured: `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GEMINI_API_KEY`
2. `practices.enabled` is true if you expect AI practice review
3. `practices.guidelines` is not empty

If no provider is configured, Sentinel CI falls back to static explanations.

Quick fix:

- Add one AI provider secret and re-run the PR workflow

## 6. Config appears ignored

Check:

1. The file name is `.sentinel-ci.yml`
2. The file is at repository root
3. YAML indentation is valid
4. Exclude paths actually match your repo layout

Quick fix:

- Validate with a minimal config first, then add rules incrementally

## 7. Unknown policy pack

Cause:
A selected pack in `policy.packs` does not exist.

Fix:

1. Verify all pack names under `policy.packs`
2. Verify all parent names under `extends`
3. Check spelling and version suffixes such as `-v1`

## 8. Circular policy pack inheritance detected

Cause:
Two or more packs reference each other recursively.

Fix:

1. Flatten the pack structure
2. Use a single parent chain
3. Avoid A -> B -> A style inheritance

## 9. Findings are too noisy

Try:

1. Add targeted `exclude` patterns
2. Refine `practices.guidelines`
3. Use standard instead of strict policy profiles
4. Run CodeQL only where deeper analysis is worth the latency

## 10. Pre-push validation blocks every push

Check:

1. `hooks.pre_push.block_on_severity`
2. Whether strict mode is intended for that repository
3. Whether the repo should use a lighter profile temporarily

## Fast Debug Checklist

1. Check workflow permissions
2. Check `.sentinel-ci.yml` file name and location
3. Check action inputs in the workflow
4. Check AI secrets if AI output is expected
5. Check CodeQL enablement and language settings
6. Check blocking severity rules

## Escalation Path

If the issue still persists:

1. Capture workflow logs from the failing run
2. Copy the relevant `.sentinel-ci.yml` and workflow sections
3. Check [ERROR_CODES.md](../reference/ERROR_CODES.md) for matching finding/error categories
4. Open an issue with reproducible steps in this repository

## Known Limitations

1. Forked pull requests may have restricted token permissions depending on repository settings.
2. AI output is unavailable when no provider key is configured or provider quota is exceeded.
3. CodeQL runtime can be long on large monorepos unless languages are scoped explicitly.
4. Preview policy-pack behavior may change across upcoming releases.

## More References

- One-page installation: [INSTALLATION.md](./INSTALLATION.md)
- Full setup guide: [SETUP.md](./SETUP.md)
- Error reference: [ERROR_CODES.md](../reference/ERROR_CODES.md)
- Rule engine guide: [RULE_ENGINE.md](../reference/RULE_ENGINE.md)
- Advantages and value summary: [docs/features/advantages-of-sentinel-ci.md](../features/advantages-of-sentinel-ci.md)
