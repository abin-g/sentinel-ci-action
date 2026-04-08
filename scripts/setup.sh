#!/bin/bash
set -e

# Colors for terminal styling
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "=================================================="
echo "      🛡️ SENTINEL CI - SETUP WIZARD 🛡️      "
echo "=================================================="
echo -e "${NC}"
echo "This wizard will install Sentinel CI (AI Code Guardian engine) for GitHub Actions"
echo "and configuration file into your target repository."
echo ""

# 1. Ask for target repository path
read -p "📁 Enter the absolute or relative path to your target project folder (e.g., ../my-project or .): " TARGET_DIR

# Check if directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Directory '$TARGET_DIR' does not exist.${NC}"
    exit 1
fi

# Ensure it's a git repository (optional but good practice)
if [ ! -d "$TARGET_DIR/.git" ]; then
    echo -e "${YELLOW}Warning: '$TARGET_DIR' does not appear to be a Git repository.${NC}"
    read -p "Do you want to continue anyway? (y/N): " FORCE_GIT
    if [[ ! "$FORCE_GIT" =~ ^[Yy]$ ]]; then
        echo "Setup aborted."
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}--- Configuration Options ---${NC}"

read -p "🛡️ Use maximum protection preset (recommended)? (Y/n): " MAX_PROTECTION
MAX_PROTECTION=${MAX_PROTECTION:-Y}

read -p "🧩 Scaffold preview policy-pack template instead of basic config? (y/N): " USE_POLICY_PRESETS
USE_POLICY_PRESETS=${USE_POLICY_PRESETS:-N}

POLICY_TEMPLATE_KIND=""
POLICY_SELECTED_PACK=""
if [[ "$USE_POLICY_PRESETS" =~ ^[Yy]$ ]]; then
  read -p "📦 Choose policy template type - backend or frontend? (backend/frontend): " POLICY_TEMPLATE_KIND
  POLICY_TEMPLATE_KIND=${POLICY_TEMPLATE_KIND:-backend}

  if [[ "$POLICY_TEMPLATE_KIND" == "frontend" ]]; then
    read -p "🔒 Choose frontend protection profile - standard or strict? (standard/strict): " FRONTEND_PROFILE
    FRONTEND_PROFILE=${FRONTEND_PROFILE:-standard}
    if [[ "$FRONTEND_PROFILE" == "strict" ]]; then
      POLICY_SELECTED_PACK="team-web-public-v1"
    else
      POLICY_SELECTED_PACK="team-web-react-v1"
    fi
  else
    POLICY_TEMPLATE_KIND="backend"
    read -p "🔒 Choose backend protection profile - standard or strict? (standard/strict): " BACKEND_PROFILE
    BACKEND_PROFILE=${BACKEND_PROFILE:-standard}
    if [[ "$BACKEND_PROFILE" == "strict" ]]; then
      POLICY_SELECTED_PACK="team-payments-v1"
    else
      POLICY_SELECTED_PACK="team-backend-v1"
    fi
  fi
fi

# 2. Ask for features
read -p "🔐 Enable Security Vulnerability Scanning? (Y/n): " ENABLE_SECURITY
ENABLE_SECURITY=${ENABLE_SECURITY:-Y}

read -p "✋ Block PR merges on strict security policy (ERROR + WARNING)? (Y/n): " BLOCK_STRICT
BLOCK_STRICT=${BLOCK_STRICT:-Y}

read -p "📊 Enable Code Quality & Smell Analysis (Beta)? (Y/n): " ENABLE_QUALITY
ENABLE_QUALITY=${ENABLE_QUALITY:-Y}

read -p "🏗️ Enable Code Practices & Architecture Enforcement? (Y/n): " ENABLE_PRACTICES
ENABLE_PRACTICES=${ENABLE_PRACTICES:-Y}

read -p "🔬 Enable CodeQL deep vulnerability scanning? (Y/n): " ENABLE_CODEQL
ENABLE_CODEQL=${ENABLE_CODEQL:-Y}

read -p "⚡ Enable diff-aware PR scanning (changed files first)? (Y/n): " ENABLE_DIFF_AWARE
ENABLE_DIFF_AWARE=${ENABLE_DIFF_AWARE:-Y}

read -p "📦 Enable dependency vulnerability scanning? (Y/n): " ENABLE_DEP_SCAN
ENABLE_DEP_SCAN=${ENABLE_DEP_SCAN:-Y}

read -p "🧠 Review individual source files for AI practices? (Y/n): " REVIEW_FILES
REVIEW_FILES=${REVIEW_FILES:-Y}

read -p "📦 Maximum number of files for AI practice review (default 25): " PRACTICE_MAX_FILES
PRACTICE_MAX_FILES=${PRACTICE_MAX_FILES:-25}

read -p "🌐 Optional CodeQL languages (comma-separated, leave blank for auto-detect): " CODEQL_LANGUAGES

# 2.5 Ask for the main production branch (base branch for PR events)
read -p "🌿 Enter your main production branch name (base branch for PRs, e.g., 'main'): " PROD_BRANCH
PROD_BRANCH=${PROD_BRANCH:-main}

# 3. Process answers
if [[ "$MAX_PROTECTION" =~ ^[Yy]$ ]]; then
  ENABLE_SECURITY="Y"
  BLOCK_STRICT="Y"
  ENABLE_QUALITY="Y"
  ENABLE_PRACTICES="Y"
  ENABLE_CODEQL="Y"
  ENABLE_DIFF_AWARE="Y"
  ENABLE_DEP_SCAN="Y"
  REVIEW_FILES="Y"
fi

if [[ "$BLOCK_STRICT" =~ ^[Yy]$ ]]; then
    # Strict mode: block merge for both ERROR and WARNING security findings.
    BLOCK_ON_SEVERITY="    - ERROR\n    - WARNING"
    ACTION_BLOCK="\"true\""
else
    # Conservative mode: only block merge on ERROR.
    BLOCK_ON_SEVERITY="    - ERROR\n    # - WARNING"
    ACTION_BLOCK="\"true\""
fi

if [[ "$ENABLE_SECURITY" =~ ^[Yy]$ ]]; then CFG_SEC="true"; else CFG_SEC="false"; fi
if [[ "$ENABLE_QUALITY" =~ ^[Yy]$ ]]; then CFG_QUAL="true"; else CFG_QUAL="false"; fi
if [[ "$ENABLE_PRACTICES" =~ ^[Yy]$ ]]; then CFG_PRAC="true"; else CFG_PRAC="false"; fi
if [[ "$ENABLE_CODEQL" =~ ^[Yy]$ ]]; then CFG_CODEQL="true"; ACTION_CODEQL="\"true\""; else CFG_CODEQL="false"; ACTION_CODEQL="\"false\""; fi
if [[ "$ENABLE_DIFF_AWARE" =~ ^[Yy]$ ]]; then CFG_DIFF_AWARE="true"; ACTION_DIFF_AWARE="\"true\""; else CFG_DIFF_AWARE="false"; ACTION_DIFF_AWARE="\"false\""; fi
if [[ "$ENABLE_DEP_SCAN" =~ ^[Yy]$ ]]; then CFG_DEP_SCAN="true"; ACTION_DEP_SCAN="\"true\""; else CFG_DEP_SCAN="false"; ACTION_DEP_SCAN="\"false\""; fi
if [[ "$REVIEW_FILES" =~ ^[Yy]$ ]]; then CFG_REVIEW_FILES="true"; else CFG_REVIEW_FILES="false"; fi

CODEQL_LANG_BLOCK=""
if [[ -n "$CODEQL_LANGUAGES" ]]; then
  ACTION_CODEQL_LANGUAGES="\"${CODEQL_LANGUAGES}\""
  CODEQL_LANG_BLOCK=$(printf '  languages:\n' )
  IFS=',' read -ra CODEQL_LANG_ARRAY <<< "$CODEQL_LANGUAGES"
  for lang in "${CODEQL_LANG_ARRAY[@]}"; do
    CLEAN_LANG=$(echo "$lang" | xargs)
    if [[ -n "$CLEAN_LANG" ]]; then
      CODEQL_LANG_BLOCK+=$(printf '    - %s\n' "$CLEAN_LANG")
    fi
  done
else
  ACTION_CODEQL_LANGUAGES='""'
fi

HOOK_BLOCK_ON_SEVERITY="    - ERROR"
if [[ "$BLOCK_STRICT" =~ ^[Yy]$ ]]; then
  HOOK_BLOCK_ON_SEVERITY="    - ERROR\n    - WARNING"
fi

echo ""
echo -e "${BLUE}--- Generating Files ---${NC}"

# 4. Create .sentinel-ci.yml
CONFIG_FILE="$TARGET_DIR/.sentinel-ci.yml"
echo "Writing configuration to $CONFIG_FILE..."

if [[ "$USE_POLICY_PRESETS" =~ ^[Yy]$ ]]; then
  if [[ "$POLICY_TEMPLATE_KIND" == "frontend" ]]; then
    cat <<EOF > "$CONFIG_FILE"
# Sentinel CI policy (.sentinel-ci.yml — AI Code Guardian engine)
# Generated by Sentinel CI Setup Wizard using the preview policy-pack frontend template.
# This template is intended for the policy-as-code preset release line.

policy_packs:
  org-frontend-platform-v1:
    extends: [owasp-web, soc2]
    config:
      security:
        enabled: true
        block_on_severity: [ERROR]
      quality:
        enabled: true
        block_on_severity: []
      codeql:
        enabled: true
        mode: security
        languages: [javascript, typescript]
      hooks:
        pre_push:
          enabled: true
          block_on_severity: [ERROR]
      practices:
        enabled: true
        review_files: true
        max_files: 30
        file_extensions: [".js", ".jsx", ".ts", ".tsx"]
        guidelines:
          - "Never trust client input; validate on server or API boundaries."
          - "Avoid dangerous DOM APIs with untrusted HTML."
          - "Do not expose secrets in frontend bundles or environment files."

  team-web-react-v1:
    extends: [org-frontend-platform-v1]
    config:
      standards:
        naming:
          - rule: "React component PascalCase"
            pattern: "^[A-Z][A-Za-z0-9]*\\.(tsx|jsx)$"
            in_dirs: ["src/components", "src/pages"]
            file_extensions: [".tsx", ".jsx"]
            message: "React component files should be PascalCase."
      practices:
        guidelines:
          - "Prefer typed props and avoid any in public component APIs."
          - "Use centralized service modules for API access."

  team-web-public-v1:
    extends: [team-web-react-v1]
    config:
      security:
        block_on_severity: [ERROR, WARNING]
      hooks:
        pre_push:
          block_on_severity: [ERROR, WARNING]
      practices:
        guidelines:
          - "Avoid localStorage for sensitive tokens when stronger session patterns are available."

policy:
  packs:
    - ${POLICY_SELECTED_PACK}

exclude:
  - "dist/"
  - "coverage/"
  - "storybook-static/"
EOF
  else
    cat <<EOF > "$CONFIG_FILE"
# Sentinel CI policy (.sentinel-ci.yml — AI Code Guardian engine)
# Generated by Sentinel CI Setup Wizard using the preview policy-pack backend template.
# This template is intended for the policy-as-code preset release line.

policy_packs:
  org-platform-v1:
    extends: [owasp-web, soc2]
    config:
      security:
        enabled: true
        block_on_severity: [ERROR]
      quality:
        enabled: true
        block_on_severity: []
      codeql:
        enabled: true
        mode: security
      hooks:
        pre_push:
          enabled: true
          block_on_severity: [ERROR]
      practices:
        enabled: true
        review_files: true
        max_files: 25
        guidelines:
          - "Validate and sanitize all external input at service boundaries."
          - "Never hardcode secrets or credentials in source code."
          - "Use parameterized queries for all DB access."

  team-backend-v1:
    extends: [org-platform-v1, internal-python-layered]
    config:
      standards:
        naming:
          - rule: "Python module snake_case"
            pattern: "^[a-z0-9_]+\\.py$"
            in_dirs: ["app", "scanner", "tests"]
            file_extensions: [".py"]
            message: "Python files must use snake_case naming."
      practices:
        guidelines:
          - "Controllers should not directly access data repositories."

  team-payments-v1:
    extends: [team-backend-v1, pci]
    config:
      security:
        block_on_severity: [ERROR, WARNING]
      hooks:
        pre_push:
          block_on_severity: [ERROR, WARNING]
      practices:
        guidelines:
          - "Do not log PAN/PII or any payment-sensitive data."

policy:
  packs:
    - ${POLICY_SELECTED_PACK}

exclude:
  - "tests/fixtures/"
  - "generated/"
EOF
  fi
else
cat <<EOF > "$CONFIG_FILE"
# Sentinel CI policy (.sentinel-ci.yml — AI Code Guardian engine)
# Generated by Sentinel CI Setup Wizard

security:
  enabled: ${CFG_SEC}
  block_on_severity:
${BLOCK_ON_SEVERITY}

quality:
  enabled: ${CFG_QUAL}
  block_on_severity: []

codeql:
  enabled: ${CFG_CODEQL}
  mode: security
${CODEQL_LANG_BLOCK}  block_on_severity:
${BLOCK_ON_SEVERITY}

scan:
  diff_aware:
    enabled: ${CFG_DIFF_AWARE}
    fallback_full_scan: true

dependency_scan:
  enabled: ${CFG_DEP_SCAN}
  default_severity: WARNING
  block_on_severity:
${BLOCK_ON_SEVERITY}

practices:
  enabled: ${CFG_PRAC}
  review_files: ${CFG_REVIEW_FILES}
  max_files: ${PRACTICE_MAX_FILES}
  guidelines:
    - "Avoid direct use of eval or Function constructor."
    - "Do not keep business logic directly inside route page files."
    - "Use strong password hashing (bcrypt/argon2), never md5/sha1 for passwords."
    - "Keep components small and move reusable logic into shared modules."

hooks:
  pre_push:
    enabled: true
    block_on_severity:
${HOOK_BLOCK_ON_SEVERITY}

exclude:
  - "tests/"
  - "node_modules/"
  - ".git/"
EOF
fi

# 5. Create GitHub Action Workflow
WORKFLOW_DIR="$TARGET_DIR/.github/workflows"
WORKFLOW_FILE="$WORKFLOW_DIR/sentinel-ci.yml"

echo "Creating GitHub Actions directory at $WORKFLOW_DIR..."
mkdir -p "$WORKFLOW_DIR"

echo "Writing GitHub Action workflow to $WORKFLOW_FILE..."

cat <<EOF > "$WORKFLOW_FILE"
name: Sentinel CI

on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches:
      - ${PROD_BRANCH}

permissions:
  contents: read
  pull-requests: write

jobs:
  sentinel-ci-scan:
    name: Sentinel CI Scan
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run Sentinel CI
        uses: abin-g/sentinel-ci-action@v1
        with:
          github_token: \${{ secrets.GITHUB_TOKEN }}
          block_on_findings: ${ACTION_BLOCK}
          enable_codeql: ${ACTION_CODEQL}
          codeql_languages: ${ACTION_CODEQL_LANGUAGES}
          enable_diff_aware: ${ACTION_DIFF_AWARE}
          enable_dependency_scan: ${ACTION_DEP_SCAN}
EOF

echo ""
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo "Sentinel CI has been successfully integrated into:"
echo "  -> $TARGET_DIR"
echo ""
echo "Next steps:"
echo "1. cd $TARGET_DIR"
echo "2. git add .sentinel-ci.yml .github/workflows/sentinel-ci.yml"
echo "3. git commit -m 'chore: integrate Sentinel CI'"
echo "4. git push"
echo "5. Optional: add OPENAI_API_KEY / ANTHROPIC_API_KEY / GEMINI_API_KEY secrets for AI-enhanced practice review"
if [[ "$USE_POLICY_PRESETS" =~ ^[Yy]$ ]]; then
  echo "6. Preview note: this repo was scaffolded with policy-pack templates intended for the preset release line"
fi
echo ""
echo "Your PRs will now be automatically scanned with a maximum-protection baseline. Happy secure coding! 🚀"

# Remove this setup wizard file from the local machine after successful completion.
# We only delete when the script file itself is named `setup.sh` to avoid surprises.
SCRIPT_TO_DELETE_SRC="${BASH_SOURCE[0]}"
# Resolve to an absolute path so cleanup works reliably even if the script was invoked from another directory.
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_TO_DELETE_SRC")" && pwd)"
SCRIPT_TO_DELETE="${SCRIPT_DIR}/$(basename "$SCRIPT_TO_DELETE_SRC")"
if [[ -f "$SCRIPT_TO_DELETE" && "$(basename "$SCRIPT_TO_DELETE")" == "setup.sh" ]]; then
  echo -e "${YELLOW}Cleaning up: removing $SCRIPT_TO_DELETE${NC}"
  rm -f "$SCRIPT_TO_DELETE" || true
fi
