# Sentinel CI 🛡️

**Sentinel CI** is a professional-grade DevSecOps platform (built on the **AI Code Guardian** engine) that uses multi-agent AI to protect your codebase. It does not only find vulnerabilities — it understands your project's architecture and helps every Pull Request meet your standards.

[**View Technical Details & Architecture ➔**](./docs/architecture/TECHNICAL_DETAILS.md)

---

## 🚀 Why Sentinel CI?

In the era of AI-generated code, security vulnerabilities and architectural drift are harder to spot than ever. Standard static analysis tools (SAST) often produce too many low-value alerts, leading to "alert fatigue."

**Sentinel CI helps by:**
- **Reducing Noise:** AI filters out false positives by understanding the surrounding code context.
- **Actionable Insights:** It does not just say "Error found"—it explains *why* it is a risk and *how* to fix it.
- **Multi-Agent AI**: Supports OpenAI, Anthropic, and Gemini with auto-failover.
- **Deep Vulnerability Analysis**: Supports optional CodeQL-based deep scanning for supported languages.
- **Security Guardrails**: Maps findings to OWASP & CWE standards.
- **Policy-as-Code Presets (Preview)**: Upcoming reusable governance baselines and starter templates for multi-repo rollout.
- **Architectural Enforcement**: Define your own "Project Laws" in plain English.
- **Clean Code Insights**: Automatically detects code smells and complexity.
- **Enforcing Standards:** Catches violations of your naming conventions and architectural patterns.
- **Gatekeeping:** Acts as a hard-fail gate in your CI/CD pipeline when you configure it to block merges.

### ⚡ Advantages at a Glance (Short)

- **Fast adoption:** Get running with a one-page installer flow.
- **Lower review fatigue:** Prioritized findings reduce noisy PR comments.
- **Better developer guidance:** Findings include fix-focused explanations.
- **Flexible governance:** Enforce org standards with policy-as-code presets.
- **Scalable security:** Combine lightweight checks with deeper optional CodeQL scans.

See full details here: [Advantages of Sentinel CI](./docs/features/advantages-of-sentinel-ci.md)

---

## 🛠️ Getting Started

You can use the interactive setup wizard or manual configuration.

### 1️⃣ Interactive Setup (Recommended)
Run the installer in your terminal to scaffold everything you need in seconds.

```bash
curl -sL https://raw.githubusercontent.com/abin-g/sentinel-ci-action/master/scripts/setup.sh -o setup.sh
chmod +x setup.sh && ./setup.sh
```

### 2️⃣ Manual Integration
If you prefer total control, add the GitHub Action and configuration file yourself.

> See the [Manual Setup Guide](./docs/guides/SETUP.md).

### 3️⃣ Copy-Paste Quickstart

If you want working examples without extra reading, start here:

- [Minimal setup (fastest)](./docs/guides/INSTALLATION.md#copy-paste-quickstart)
- [AI-enabled setup](./docs/guides/INSTALLATION.md#quickstart-with-ai-enabled)
- [CodeQL-enabled setup](./docs/guides/INSTALLATION.md#quickstart-with-codeql-enabled)
- [If something fails](./docs/guides/TROUBLESHOOTING.md)

---

## 📖 Explore the Documentation

| Document | Description |
|----------|-------------|
| [**One-Page Installation Guide**](./docs/guides/INSTALLATION.md) | Fastest path to install Sentinel CI in one page. |
| [**Troubleshooting Guide**](./docs/guides/TROUBLESHOOTING.md) | Fix common workflow, config, AI, and CodeQL issues quickly. |
| [**Setup Guide**](./docs/guides/SETUP.md) | How to install and configure Sentinel CI in your project. |
| [**Advantages of Sentinel CI**](./docs/features/advantages-of-sentinel-ci.md) | Detailed breakdown of business and engineering benefits. |
| [**Rule Engine Guide**](./docs/reference/RULE_ENGINE.md) | In-depth `.sentinel-ci.yml` reference, schema, policies, and troubleshooting. |
| [**Feature & AI Guide**](./docs/reference/FEATURES.md) | AI agents and how to test/enable them. |
| [**Vulnerability Scanner Improvements**](./docs/features/vulnerability-scanner-improvements.md) | CodeQL setup, inputs, supported languages, and troubleshooting. |
| [**Policy-as-Code Presets (Preview)**](./docs/features/policy-as-code-presets.md) | Planned reusable policy packs, inheritance, and rollout templates. |
| [**Error & Analysis Reference**](./docs/reference/ERROR_CODES.md) | Findings, severity levels, and troubleshooting. |
| [**Roadmap & Lifecycle**](./docs/roadmap/ROADMAP.md) | Direction and upcoming features. |

## 📌 Feature Availability

| Feature | Status |
|---------|--------|
| Core Semgrep security scanning | Available |
| AI provider failover | Available |
| Optional CodeQL deep scanning | Available |
| Deterministic standards checks | Available |
| Policy-as-code preset packs | Preview |

---

## 🛡️ Governance & Policy

Sentinel CI uses a policy-driven approach. Define what severities block a merge in your `.sentinel-ci.yml` file. By default, many setups block Pull Requests containing **ERROR** level security findings (you can add **WARNING** for strict mode). Legacy `.ai-guardian.yml` is still read if `.sentinel-ci.yml` is missing.

> **Note:** The GitHub Action package may still be published as `abin-g/sentinel-ci-action` for backward compatibility.

---

## 🤝 Contributing & Support

We welcome contributions! If you encounter issues or have questions about scan results, check our [Error Reference](./docs/reference/ERROR_CODES.md) or open an issue in [this repository](https://github.com/abin-g/sentinel-ci-action/issues).

---

## ⚖️ License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. See [docs/legal/LICENSE](./docs/legal/LICENSE) for details.
