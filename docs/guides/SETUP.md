# Sentinel CI Setup Guide 🛠️

This guide covers how to integrate **Sentinel CI** (AI Code Guardian engine) into your GitHub repository using the interactive setup wizard or manual configuration.

---

## 🏗️ Method 1: Interactive Setup Wizard (Fastest)

Our interactive setup script walks you through configuration and generates the necessary files in your project.

### Usage

1. Open your terminal and navigate to the root of your target project.
2. Run the following command:
   ```bash
   curl -sL https://raw.githubusercontent.com/abin-g/sentinel-ci-action/master/scripts/setup.sh -o setup.sh
   chmod +x setup.sh && ./setup.sh
   ```

### What the Wizard Does:
- **Scaffolds Config:** Creates a `.sentinel-ci.yml` file based on your feature preferences.
- **Sets up Workflow:** Creates `.github/workflows/sentinel-ci.yml` with the correct permissions and triggers.
- **Configures Governance:** Lets you choose strict vs conservative merge blocking.
- **Applies a Maximum-Protection Baseline:** The recommended wizard path enables strict blocking, CodeQL, pre-push enforcement, and AI practice review defaults.

### Recommended Wizard Mode

Choose `maximum protection preset` when prompted if you want the strongest default security posture.

That preset scaffolds:

1. Strict merge blocking on `ERROR` and `WARNING`
2. CodeQL deep vulnerability analysis enabled
3. AI practice review with per-file scanning enabled
4. Pre-push hook policy defaults in `.sentinel-ci.yml`
5. A stronger starter `.sentinel-ci.yml` than the previous minimal setup flow

### Preview Wizard Mode: Policy-Pack Templates

The setup wizard can also scaffold a preview policy-pack template directly into `.sentinel-ci.yml`.

When enabled, the wizard asks:

1. Whether to use policy-pack scaffolding
2. Whether the repository is `backend` or `frontend`
3. Whether to use a `standard` or `strict` protection profile

Generated pack selections:

1. Backend standard: `team-backend-v1`
2. Backend strict: `team-payments-v1`
3. Frontend standard: `team-web-react-v1`
4. Frontend strict: `team-web-public-v1`

This mode is intended for the policy-as-code preset release line and is best used when you want the repository to start from a reusable org policy model instead of a flat config file.

> **Legacy:** Older installs may use `sentinel-ci.yml` as the workflow filename; both work the same way.

---

## 🛠️ Method 2: Manual Installation

If you prefer to configure the action manually, follow these steps:

### 1. Create the Workflow File
Create a file at `.github/workflows/sentinel-ci.yml` with the following content:

```yaml
name: Sentinel CI

on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [main, master, release]

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
          # Optional: scan_path: "."
          # Optional: block_on_findings: "true"
          # Optional: enable_codeql: "true"
          # Optional: codeql_languages: "python,javascript"
```

### 2. Add the Configuration File
Create a `.sentinel-ci.yml` file in your repository root to control the scanner's behavior (legacy `.ai-guardian.yml` is still supported if the new file is absent):

```yaml
security:
  enabled: true
  # Severities that will cause the CI check to fail
  block_on_severity:
    - ERROR

exclude:
  - "tests/**"
  - "node_modules/**"
  - "dist/**"
```

### 3. Optional: Enable Deep CodeQL Analysis

If you want deeper vulnerability analysis, enable CodeQL directly in the workflow:

```yaml
      - name: Run Sentinel CI
        uses: abin-g/sentinel-ci-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          enable_codeql: "true"
          codeql_languages: "python,typescript"
```

You can also set CodeQL behavior in `.sentinel-ci.yml`:

```yaml
codeql:
  enabled: true
  mode: security
  languages:
    - python
    - typescript
  block_on_severity:
    - ERROR
```

For deeper operational guidance, see [docs/features/vulnerability-scanner-improvements.md](../features/vulnerability-scanner-improvements.md).

---

## 🔑 Authentication

Sentinel CI requires a `GITHUB_TOKEN` to post comments on your Pull Requests.

- **GitHub Actions:** The `${{ secrets.GITHUB_TOKEN }}` is automatically provided by GitHub for every workflow run. No manual secret setup is required as long as you have `pull-requests: write` permissions defined in your workflow.

---

## 🚀 Post-Installation

Once the files are added:
1. Commit the changes: `git add . && git commit -m "chore: add Sentinel CI"`
2. Push to your repository: `git push`
3. Open a test Pull Request to see the scan in action!

## Troubleshooting Setup Issues

For complete troubleshooting, use [docs/guides/TROUBLESHOOTING.md](./TROUBLESHOOTING.md).

### The action runs but no PR comment is posted

Check:

1. Your workflow includes `pull-requests: write` permissions.
2. The action is running on a pull request event.
3. `github_token` is set to `${{ secrets.GITHUB_TOKEN }}` or another token with PR comment permissions.

### CodeQL does not appear to run

Check:

1. `enable_codeql: "true"` is set in the workflow, or `codeql.enabled: true` is set in `.sentinel-ci.yml`.
2. Your repository contains a supported language.
3. `block_on_findings: "false"` is not masking expected failure behavior.
