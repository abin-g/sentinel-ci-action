# Policy-as-Code Presets

This guide documents the policy-as-code preset system planned for the next Sentinel CI release.

## Availability

This feature is documented ahead of release so teams can prepare rollout plans, baseline policies, and repository templates.

It introduces reusable policy packs, inheritance, and repository-level overrides for Sentinel CI configuration.

## What It Solves

Without policy presets, teams often repeat the same rules across many repositories.

Policy-as-code presets let you:

- Reuse built-in policy packs
- Create organization-specific policy packs
- Inherit from parent packs
- Override policy values per repository
- Roll out governance gradually with versioned pack names

## Core Concepts

### Built-in packs

Planned built-in packs:

- `owasp-web`
- `pci`
- `soc2`
- `internal-python-layered`

### Custom packs

Custom organization packs are defined under `policy_packs`.

### Inheritance

Each custom pack can extend one or more parent packs with `extends`.

### Final overrides

Top-level config sections still override any inherited policy pack value.

## Example

```yaml
policy_packs:
  org-platform-v1:
    extends: [owasp-web, soc2]
    config:
      security:
        block_on_severity: [ERROR]

  payments-v1:
    extends: [org-platform-v1, pci]
    config:
      security:
        block_on_severity: [ERROR, WARNING]

policy:
  packs:
    - payments-v1

codeql:
  enabled: false
```

Resolution order:

1. Sentinel default config
2. Selected `policy.packs`
3. Inherited parents from `extends`
4. Explicit top-level overrides in `.sentinel-ci.yml`

## Strict Validation

Planned validation behavior:

- Unknown pack names fail configuration loading
- Circular inheritance fails configuration loading
- Invalid `policy` or `policy_packs` shapes fail configuration loading

This is intended to fail CI early rather than silently ignoring misconfiguration.

## Starter Templates

Starter rollout templates are included here:

- `templates/policies/org-policy-starter.sentinel-ci.yml`
- `templates/policies/org-frontend-policy-starter.sentinel-ci.yml`

The interactive setup wizard can also scaffold one of these starter patterns directly into `.sentinel-ci.yml`.

Wizard choices:

1. Template type: `backend` or `frontend`
2. Protection profile: `standard` or `strict`

Wizard-selected packs:

1. Backend standard -> `team-backend-v1`
2. Backend strict -> `team-payments-v1`
3. Frontend standard -> `team-web-react-v1`
4. Frontend strict -> `team-web-public-v1`

## Rollout Strategy

Recommended rollout:

1. Create an org baseline such as `org-platform-v1`
2. Create domain packs such as `payments-v1` or `frontend-v1`
3. Apply one selected pack per repository
4. Add only minimal top-level overrides per repository
5. Version packs deliberately when making breaking governance changes

## Troubleshooting

### A repository does not behave as expected

Check:

1. The selected pack exists under `policy.packs`
2. Parent names in `extends` are valid
3. Top-level config is not overriding inherited values unexpectedly
4. YAML indentation is valid

### A repository should use a different baseline

Create a new versioned pack instead of mutating old behavior unexpectedly:

- `org-platform-v1`
- `org-platform-v2`

This keeps rollouts controlled across many repositories.

## Recommended Naming Conventions

- `org-platform-v1` for company-wide baselines
- `team-backend-v1` for backend defaults
- `team-web-react-v1` for frontend defaults
- `payments-v1` for compliance-heavy repos

## Release Notes Summary

This feature turns Sentinel CI configuration into reusable governance artifacts that can be versioned, reviewed, and rolled out across an organization.