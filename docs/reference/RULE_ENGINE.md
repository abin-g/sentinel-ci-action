# Sentinel CI Rule Engine Guide

This document explains how to configure `.sentinel-ci.yml` (AI Code Guardian engine) for security gates, quality scanning, deterministic standards, and AI practice review.

**Legacy:** If you still have `.ai-guardian.yml` at the repo root and no `.sentinel-ci.yml`, the scanner loads the legacy file and prints a hint to rename it.

---

## What `.sentinel-ci.yml` Controls

Sentinel CI supports four policy layers:

Preview: upcoming releases extend this with reusable policy packs and inheritance.

1. `security`  
   Controls merge-blocking behavior by severity (`ERROR`, `WARNING`, `INFO`).

2. `quality`  
   Enables additional Semgrep quality rulesets (`p/ci`, `p/default`) on top of baseline scanning.

3. `codeql`
  Enables deep CodeQL analysis for supported languages.

4. `standards`  
   Deterministic (non-AI) checks for imports, naming patterns, and required structure.

5. `practices`  
   AI-driven review using your plain-English engineering guidelines.

---

## Full Configuration Template

Use this as a starting point:

```yaml
security:
  enabled: true
  block_on_severity:
    - ERROR

quality:
  enabled: true
  block_on_severity: []

codeql:
  enabled: false
  mode: security
  languages: []
  block_on_severity:
    - ERROR

practices:
  enabled: true
  block_on_severity:
    - ERROR
  guidelines:
    - "Avoid direct use of eval or Function constructor."
    - "Use parameterized DB access; do not build raw SQL with user input."
    - "Keep route/controller files thin and move business logic to services."

standards:
  imports:
    - rule: "forbid_pickle"
      pattern: "import\\s+pickle|from\\s+pickle\\s+import"
      in_dirs:
        - "app/"
      message: "Do not use pickle in runtime code."
  naming:
    - rule: "python_service_naming"
      pattern: "^[a-z_]+\\.py$"
      in_dirs:
        - "app/services/"
      message: "Service modules must use snake_case file naming."
  structure:
    - rule: "require_readme"
      path: "README.md"
      required: true
      message: "Repository must include README.md."
    - rule: "require_security_doc"
      path: "docs/SECURITY.md"
      required: true
      message: "Security policy must be documented in docs/SECURITY.md."

exclude:
  - "tests/"
  - "node_modules/"
  - ".git/"
  - ".next/"
  - "dist/"
```

---

## Section-by-Section Reference

### `security`

```yaml
security:
  enabled: true
  block_on_severity:
    - ERROR
    - WARNING
```

- `enabled`: turn security gate on/off.
- `block_on_severity`: list of severities that fail CI.
- Common policy:
  - strict: `ERROR + WARNING`
  - balanced: `ERROR` only

---

### `quality`

```yaml
quality:
  enabled: true
  block_on_severity: []
```

- `enabled: true` adds quality-focused Semgrep packs.
- `block_on_severity` is currently informational in many setups; primary CI gate is driven by `security.block_on_severity`.

---

### `practices`

```yaml
practices:
  enabled: true
  block_on_severity:
    - ERROR
  guidelines:
    - "Do not keep business logic in controller files."
```

- `guidelines` must contain items, otherwise practice review has little/no effect.
- For AI-backed guidance, provide at least one API key in workflow env:
  - `OPENAI_API_KEY`
  - `ANTHROPIC_API_KEY`
  - `GEMINI_API_KEY`

---

### `codeql`

```yaml
codeql:
  enabled: true
  mode: security
  languages: [python, javascript]
  block_on_severity:
    - ERROR
```

- `enabled`: turn deep CodeQL analysis on/off.
- `mode`: `security` or `quality`.
- `languages`: explicit language list. If empty, Sentinel CI auto-detects supported languages.
- `block_on_severity`: severities from CodeQL findings that should fail CI.

For setup and examples, see [docs/features/vulnerability-scanner-improvements.md](../features/vulnerability-scanner-improvements.md).

---

### `standards` (Deterministic Rules)

These checks are regex/path based and do not require AI.

#### `standards.imports`
- List of rules with:
  - `pattern`: regex to detect disallowed imports/usage
  - `in_dirs`: optional directory scope
  - `message`: human-readable policy message

#### `standards.naming`
- List of rules with:
  - `pattern`: regex for file name format
  - `in_dirs`: directory scope
  - `message`: violation message

#### `standards.structure`
- List of rules with:
  - `path`: required path in repository
  - `required`: true/false
  - `message`: violation message

---

## Real-World Policy Profiles

### 1) Strict Security Gate (Recommended for production)

```yaml
security:
  enabled: true
  block_on_severity: [ERROR, WARNING]
```

### 2) Report-Only Pilot (Adoption phase)

```yaml
security:
  enabled: true
  block_on_severity: [ERROR]
```

Combine with action input:

```yaml
block_on_findings: "false"
```

### 3) Architecture Governance Mode

```yaml
standards:
  structure:
    - rule: "require_domain_layer"
      path: "app/domain"
      required: true
      message: "Domain layer folder must exist."
```

### 4) Policy-as-Code Presets (Preview)

Upcoming releases support reusable policy packs and inheritance:

```yaml
policy_packs:
  org-platform-v1:
    extends: [owasp-web, soc2]
    config:
      security:
        block_on_severity: [ERROR]

policy:
  packs: [org-platform-v1]
```

See [docs/features/policy-as-code-presets.md](../features/policy-as-code-presets.md).

---

## Troubleshooting

### Only static findings appear

Check:
1. `practices.guidelines` is non-empty.
2. AI keys are present in workflow env if AI review is expected.
3. `standards` uses list-based rules (not custom object shapes).

### PR comment not posted

Check:
1. Workflow permissions include:
   - `contents: read`
   - `pull-requests: write`
2. Token is valid (`github_token` input or `${{ secrets.GITHUB_TOKEN }}`).
3. Repository/fork secret restrictions.

### Config appears ignored

Check:
1. Policy file is `.sentinel-ci.yml` at repository root (or legacy `.ai-guardian.yml` only if the new file is absent).
2. YAML indentation is valid.
3. Exclude paths are correct for your project layout.

### CodeQL did not run

Check:

1. `codeql.enabled` is true or workflow input `enable_codeql` is enabled.
2. `languages` is valid or the repo contains a supported language.
3. Your workflow timeout is high enough for CodeQL database creation.

### Policy pack configuration fails (Preview)

Check:

1. All selected pack names exist.
2. `extends` references valid parent packs.
3. There is no circular inheritance chain.
4. Top-level overrides are not masking inherited behavior unexpectedly.

---

## Minimal Valid Config

```yaml
security:
  enabled: true
  block_on_severity:
    - ERROR
```

This is the smallest valid policy for CI gatekeeping.
