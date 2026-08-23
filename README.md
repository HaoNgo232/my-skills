# My Agent Skills Collection 🛠️

A curated collection of modular, reusable AI Agent Skills designed for modern coding agents (Antigravity, Claude Code, Cursor, Codex, Gemini CLI, and other `skills.sh`-compatible agents).

Each skill is maintained as an independent module containing standard YAML frontmatter metadata, domain workflows, specialized prompts, and quality verification gates.

---

## 📦 Available Skills

| Skill | Description | Direct Install Command |
| :--- | :--- | :--- |
| **[orchestrator](./orchestrator/README.md)** | Coordinates multi-agent workflows for complex programming, architecture, and engineering tasks with DAG task decomposition, tiered models, reactive supervision, and quality gates. | `npx skills add HaoNgo232/my-skills --skill orchestrator` |

---

## 🚀 Quick Start & Installation

### 1. Install a specific skill (Recommended)
You can cherry-pick and install any individual skill directly into your current project:

```bash
# Install Orchestrator
npx skills add HaoNgo232/my-skills --skill orchestrator

# Install Logging Codebase Auditor
npx skills add HaoNgo232/my-skills --skill logging-codebase-auditor
```

### 2. Install all skills in this collection
To install the entire collection of skills into your project:

```bash
npx skills add HaoNgo232/my-skills
```

---

## 📁 Repository Structure

```
my-skills/
├── README.md                          # Main registry & documentation
├── .gitignore
├── orchestrator/                      # Multi-agent orchestrator skill
│   ├── SKILL.md                       # Standard Agent Skill specification
│   └── README.md                      # Documentation & usage guide
└── logging-codebase-auditor/          # Logging quality & observability auditor
    ├── SKILL.md                       # Skill specification
    ├── README.md                      # Documentation
    ├── LICENSE                        # MIT License
    ├── assets/                        # Diagrams & visual assets
    └── references/                    # Reference guidelines
```

---

## ➕ Adding a New Skill

To add a new skill to this repository:
1. Create a new directory under root: `mkdir <skill-name>`
2. Add `SKILL.md` with standard frontmatter:
   ```yaml
   ---
   name: <skill-name>
   description: <short clear description of what this skill does>
   ---
   ```
3. Add `README.md` inside the skill directory with installation instructions and examples.
4. Update the **Available Skills** table in this root `README.md`.

---

## 📄 License

MIT License © 2026 [Ngo Gia Hao (HaoNgo232)](https://github.com/HaoNgo232)
