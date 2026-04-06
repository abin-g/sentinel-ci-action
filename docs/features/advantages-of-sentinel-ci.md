# Advantages of Using Sentinel CI

This page expands on the short advantages summary in the main README and explains the practical value for engineering teams.

## 1. Faster Security Reviews with Less Noise

Sentinel CI uses contextual analysis to reduce low-value alerts that often create review fatigue in PRs.

Why this matters:

- Reviewers spend less time triaging obvious false positives
- Teams focus on real risks first
- Security checks become more sustainable over time

## 2. Actionable Findings Instead of Generic Alerts

Sentinel CI is designed to provide not just detection, but guidance.

Why this matters:

- Developers get clearer remediation direction
- Fixes are applied faster during PR review
- Fewer back-and-forth cycles between security and development

## 3. Flexible AI Provider Strategy with Failover

Sentinel CI supports multiple AI providers for resilience and flexibility.

Why this matters:

- Teams are not locked to one provider
- Workflows remain usable during temporary provider outages
- Organizations can align with internal vendor policy

## 4. Policy-as-Code Governance for Consistency

Teams can standardize rules with reusable policy presets and organization-level baselines.

Why this matters:

- Security and quality rules are consistent across repositories
- Rollout is simpler for platform teams
- Exceptions and strictness are controlled in a predictable way

## 5. Optional Deep Scanning with CodeQL

Sentinel CI supports deeper vulnerability analysis through optional CodeQL integration.

Why this matters:

- Critical repositories can use stronger scanning depth
- Teams can balance runtime and risk based on repo type
- Security posture improves without forcing one-size-fits-all defaults

## 6. Architecture and Standards Enforcement

Sentinel CI can enforce project-specific engineering rules, naming conventions, and quality constraints.

Why this matters:

- Reduces architectural drift in growing codebases
- Makes code reviews more objective and repeatable
- Improves long-term maintainability

## 7. CI Gatekeeping with Configurable Strictness

Sentinel CI can block merges based on severity thresholds you define.

Why this matters:

- Prevents high-risk changes from reaching main branches
- Supports strict mode for critical repos and lighter mode for others
- Aligns enforcement with team maturity and delivery needs

## Recommended Reading

- Quick install: [INSTALLATION.md](../guides/INSTALLATION.md)
- Setup details: [SETUP.md](../guides/SETUP.md)
- Rules and policy schema: [RULE_ENGINE.md](../reference/RULE_ENGINE.md)
- Troubleshooting: [TROUBLESHOOTING.md](../guides/TROUBLESHOOTING.md)
