# Technical Details & Architecture

**Sentinel CI** (AI Code Guardian engine) is not just another wrapper around an LLM. It is a hybrid-analysis engine designed to provide industrial-grade security and architectural governance.

## 🏗️ How It Works (The Core Engine)

The platform follows a **"Static-Analysis First, AI-Refined"** methodology. This ensures that every finding is grounded in real code patterns before the AI provides context.

### 1. The Scanning Layer (Industrial Standards)
We leverage **Semgrep** as the baseline scanner and add **optional CodeQL** for deeper vulnerability analysis on supported languages.
- **Standards**: Our rulesets are mapped directly to **OWASP Top 10** and **CWE (Common Weakness Enumeration)**.
- **Rulesets**:
    - `p/security-audit`: Deep security checks for vulnerabilities.
    - `p/secrets`: Detection of hardcoded keys and tokens.
    - `p/ci` & `p/default`: Industry-standard code quality and maintainability rules.
    - CodeQL security and code-scanning suites for deeper analysis when enabled.

### 2. The Context Discovery Layer
Before any analysis, the platform builds a "Project Identity":
- **Architectural Enforcement**: Define both plain-English guidelines (AI) and strict "Hard Laws" (Deterministic).
- **Policy-as-Code Direction**: Upcoming releases add reusable pack-based policies for multi-repo rollout.
- **Hard Laws**: Block forbidden imports, enforce naming patterns, and verify repo structure.
- **Clean Code Insights**: Automatically detects code smells and complexity.
- **Tech Stack Detection**: Automatically identifies if the project is Python, Node.js, etc.
- **Dependency Mapping**: Reads `requirements.txt` or `package.json` to understand which frameworks (Django, React, FastAPI) are being used.
- **Tree Analysis**: Generates a recursive map of the codebase to understand architectural hierarchies.

### 3. The AI Intelligence Layer (Multi-Agent)
Finding a bug is only half the battle. Explaining it and fixing it is the other half.
*   **Context Injection**: The AI Agent receives the "Project Identity." This allows it to say things like "Since you're using Django, you should use `make_password` instead of manual hashing."
*   **Orchestration**: We use a priority-based failover system. If OpenAI is throttled, the agent automatically switches to Anthropic or Gemini.

### 4. The Deterministic Standards Layer ⚖️
For rules that are non-negotiable, we use a regex-based enforcer that doesn't rely on AI:
- **Import Guard**: Prevents architectural violations (e.g., "Web -> Data" leaks).
- **Naming Guard**: Ensures consistent naming conventions across the team.
- **Structural Guard**: Verifies that required project files exist.
- **Performance**: These checks represent zero AI token cost and execute in milliseconds.

---

## 🆚 Comparison with Other Platforms

| Feature | Snyk / SonarQube | Sentinel CI |
| :--- | :--- | :--- |
| **Security Coverage** | Excellent (Static) | Excellent (Static + AI Explanations) |
| **Custom Architecture** | Hard to define (Regex only) | **Natural Language Guidelines** |
| **Suggested Fixes** | Templates | **Contextual Code Fixes** |
| **Developer UX** | High noise / Generic | Human-readable & Grouped Findings |
| **Multi-LLM Choice** | Vendor Locked | **Any Provider (OpenAI, Gemini, Anthropic)** |

---

## 🛠️ Technical Methodology

### Security Matrix
We evaluate findings across three core dimensions:
1.  **Severity**: Impact on the system (ERROR vs. WARNING).
2.  **Exploitability**: How easy is it for an attacker to reach this code?
3.  **Remediation Effort**: How complex is the suggested fix?

### AI Agent industrial Standards
Our AI Agents use a **"Expert Chain-of-Thought"** prompt engineering technique. When performing a review:
1.  **Identify**: Pinpoint the exact line of risk.
2.  **Verify**: Cross-reference with the project structure to avoid false positives.
3.  **Correct**: Generate a fix that respects the existing coding style and imports.

## 🔐 Reliability & Failover
Because security never sleeps, our engine includes a **Static Fallback Mode**. If all AI providers are down, the system automatically detects this and serves high-quality, pre-computed security templates. Your PRs will **never** be blocked by provider downtime.
