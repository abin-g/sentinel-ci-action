# Diff-Aware Scanning

Diff-aware scanning analyzes changed files first for pull requests, instead of always scanning the full repository.

This improves speed and reduces noise from legacy findings unrelated to the current PR.

## Why it matters

- Faster PR feedback loops
- Lower alert fatigue
- Better focus on newly introduced risk
- Smoother adoption on large, older repositories

## How it works

When enabled:

1. Sentinel CI resolves changed files for the current PR
2. Semgrep scans only those changed files
3. If changed files cannot be resolved and fallback is enabled, Sentinel CI runs a full scan

## Enable from workflow

```yaml
- name: Run Sentinel CI
  uses: abin-g/sentinel-ci-action@v1
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    enable_diff_aware: "true"
```

Default: `true`

## Enable from config

```yaml
scan:
  diff_aware:
    enabled: true
    fallback_full_scan: true
```

## Recommended settings

For most teams:

```yaml
scan:
  diff_aware:
    enabled: true
    fallback_full_scan: true
```

For strict changed-files-only workflows:

```yaml
scan:
  diff_aware:
    enabled: true
    fallback_full_scan: false
```

Use strict mode only if your CI environment reliably provides PR diff context.

## Troubleshooting

### Diff-aware appears enabled but full scan still runs

Likely cause:
Changed files could not be resolved and fallback triggered.

Check:

1. Workflow is running on pull request events
2. Repository checkout includes required history (`fetch-depth: 0` recommended)
3. `scan.diff_aware.fallback_full_scan` behavior matches your expectations

### No findings after enabling strict changed-files mode

Likely cause:
No changed files were resolved and fallback is disabled.

Fix:

1. Set `fallback_full_scan: true`
2. Ensure PR event context is available

## Best practice rollout

1. Enable diff-aware with fallback first
2. Compare scan duration and finding quality for a week
3. Tune excludes and severity policies
4. Consider strict changed-files mode only after validation
