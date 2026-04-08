# Sentinel CI One-Page Installation Guide

Use this page for the fastest, end-to-end setup in a single document.

## What you get after setup

- Automated PR checks for security and code-quality policies
- Optional AI-backed explanations for findings
- Optional CodeQL deep analysis for supported languages
- Policy-driven merge blocking using your defined severity levels

## Option 1: Interactive Setup (Recommended)

Run the setup wizard:

```bash
curl -sL https://raw.githubusercontent.com/abin-g/sentinel-ci-action/master/scripts/setup.sh -o setup.sh
chmod +x setup.sh && ./setup.sh
```

Recommended choices:

1. Choose `maximum protection preset`
2. Enable CodeQL
3. Enable AI practices review
4. Keep strict blocking enabled

The wizard generates:

- `.sentinel-ci.yml`
- `.github/workflows/sentinel-ci.yml`

When to use this option:

- You want to go live quickly with good defaults
- You are onboarding a team that needs standard setup

## Copy-Paste Quickstart

Use one of these blocks directly in `.github/workflows/sentinel-ci.yml`.

### Minimal quickstart (fastest)

```yaml
name: Sentinel CI

on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [main]

permissions:
  contents: read
  pull-requests: write

jobs:
  sentinel-ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run Sentinel CI
        uses: abin-g/sentinel-ci-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Quickstart with AI enabled

```yaml
name: Sentinel CI

on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [main]

permissions:
  contents: read
  pull-requests: write

jobs:
  sentinel-ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run Sentinel CI
        uses: abin-g/sentinel-ci-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
```

### Quickstart with CodeQL enabled

```yaml
name: Sentinel CI

on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [main]

permissions:
  contents: read
  pull-requests: write

jobs:
  sentinel-ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run Sentinel CI
        uses: abin-g/sentinel-ci-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          enable_codeql: "true"
          codeql_languages: "python,javascript"
          enable_diff_aware: "true"
          enable_dependency_scan: "true"
```

Expected result after first PR run:

1. Action appears in the PR checks list
2. A Sentinel CI PR comment is posted
3. Merge blocking matches your configured severities

---

## Option 2: Manual Setup

Create `.github/workflows/sentinel-ci.yml`:

```yaml
name: Sentinel CI

on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [main]

permissions:
  contents: read
  pull-requests: write

jobs:
  sentinel-ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run Sentinel CI
        uses: abin-g/sentinel-ci-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          block_on_findings: "true"
          enable_codeql: "true"
          codeql_languages: "python,javascript"
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
```

Create `.sentinel-ci.yml`:

```yaml
security:
  enabled: true
  block_on_severity:
    - ERROR
    - WARNING

quality:
  enabled: true
  block_on_severity: []

codeql:
  enabled: true
  mode: security
  block_on_severity:
    - ERROR
    - WARNING

scan:
  diff_aware:
    enabled: true
    fallback_full_scan: true

dependency_scan:
  enabled: true
  default_severity: WARNING
  block_on_severity:
    - ERROR

practices:
  enabled: true
  review_files: true
  max_files: 25
  guidelines:
    - "Validate external input at boundaries."
    - "Use parameterized DB access."
    - "Avoid keeping business logic in controllers or route files."

hooks:
  pre_push:
    enabled: true
    block_on_severity:
      - ERROR
      - WARNING

exclude:
  - "tests/"
  - "node_modules/"
  - ".git/"
```

When to use this option:

- You need full control over policy and workflow details
- You want custom rules before first run

## Required GitHub Permissions

Your workflow must include:

```yaml
permissions:
  contents: read
  pull-requests: write
```

## Optional AI Secrets

Add one or more repository secrets if you want AI-enhanced explanations and practice review:

- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `GEMINI_API_KEY`

## First Validation Checklist

1. Push the workflow and config
2. Open or update a pull request
3. Confirm Sentinel CI runs in GitHub Actions
4. Confirm a PR comment is posted
5. Confirm blocking behavior matches your policy

## Quick install success criteria

You are fully installed when all of these are true:

1. Workflow appears in GitHub Actions for pull requests
2. Sentinel CI posts a PR summary comment
3. Severity blocking behavior matches `.sentinel-ci.yml`
4. Optional AI and CodeQL features run when enabled

## Where to Go Next

- Full setup details: [SETUP.md](./SETUP.md)
- Rule configuration: [RULE_ENGINE.md](../reference/RULE_ENGINE.md)
- Full benefits and advantages: [docs/features/advantages-of-sentinel-ci.md](../features/advantages-of-sentinel-ci.md)
- Scanner improvements: [docs/features/vulnerability-scanner-improvements.md](../features/vulnerability-scanner-improvements.md)
- Diff-aware scanning: [docs/features/diff-aware-scanning.md](../features/diff-aware-scanning.md)
- Dependency vulnerability scanning: [docs/features/dependency-vulnerability-scanning.md](../features/dependency-vulnerability-scanning.md)
- Policy presets: [docs/features/policy-as-code-presets.md](../features/policy-as-code-presets.md)
- Troubleshooting: [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
