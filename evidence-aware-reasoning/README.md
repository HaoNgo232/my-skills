# Evidence-Aware Reasoning

AI models have a well-known flaw: **sycophancy** — the tendency to agree with unverified user assumptions and build overconfident arguments on top of them. 

When asked *"App crashed because of a memory leak, right?"*, an AI will often blindly agree: *"Yes! Here is how to fix the memory leak..."* — sending you down a costly wild-goose chase.

This skill acts as a **cognitive brake** for your AI agent. It stops agents from treating assumptions as facts, prevents escalating uncertainty, and forces responses to stay strictly grounded in evidence.

---

## Quick Example

**User Prompt:**
> *"Our app crashed because of the new memory leak introduced in the update, right?"*

| Mode | Response Behavior |
| :--- | :--- |
| **❌ Without Skill** | *"Yes, the memory leak from the update caused the crash. Here are 5 ways to fix memory leaks..."*<br>*(Blindly agrees & invents solutions without verification)* |
| **✅ With Skill** | *"That is a possibility, but we lack verified evidence. Before debugging memory leaks, let's check crash logs and RAM usage to confirm the root cause."*<br>*(Identifies missing evidence & prevents wasted effort)* |

---

## What It Does

- **Distinguishes facts vs. assumptions**: Separates verified evidence, user claims, and model inferences.
- **Controls uncertainty**: Prevents weak assumptions ("may") from escalating into definitive statements ("is").
- **Challenges unverified premises**: Gently points out missing evidence when assumptions could lead to high-stakes decisions.
- **Uses conditional phrasing**: Keeps responses grounded with clear "If..." statements when analyzing hypotheticals.

---

## What It Doesn't Do

- Perform external web searches without tools (though it will actively use available tools to verify premises before hedging).
- Force rigid or overly long responses for simple questions.

---

## Global Prompt Installation

Automatically injects `@ear.md` into your global AI agent rules (`~/.gemini/GEMINI.md`, `~/.claude/CLAUDE.md`, `~/.cursorrules`, `~/.codex/CODEX.md`).

### ⚡ 1-Line Global Auto-Install

Run this single command to auto-install across **all detected agents**:

```bash
curl -sSL https://raw.githubusercontent.com/HaoNgo232/evidence-aware-reasoning/main/install.sh | bash
```

Or target a **specific agent** (`gemini`, `claude`, `cursor`, `codex`):

```bash
curl -sSL https://raw.githubusercontent.com/HaoNgo232/evidence-aware-reasoning/main/install.sh | bash -s -- codex
```

Or run locally after cloning:
```bash
./install.sh [all|gemini|claude|cursor|codex]
```

---

### 🌐 Supported AI Coding Agents

| Agent / Tool | Target Config File | Injection Method |
| :--- | :--- | :--- |
| **Gemini / Antigravity** | `~/.gemini/GEMINI.md` | `@ear.md` at top of file |
| **Claude Code** | `~/.claude/CLAUDE.md` | `@ear.md` at top of file |
| **Cursor** | `~/.cursorrules` | Global rule reference |
| **Codex** | `~/.codex/CODEX.md` | `@ear.md` at top of file |

---

### 🛠️ Alternative: Install as Agent Skill

If you prefer installing it as a **Skill** instead of a global prompt:

#### Option A: Using `skills` CLI
```bash
# Add from my-skills collection (Recommended)

# Or install globally as a skill
npx skills add HaoNgo232/my-skills --skill evidence-aware-reasoning -g
```
#### Option B: Manual Skill Clone
```bash
# Gemini / Antigravity Skill
git clone https://github.com/HaoNgo232/evidence-aware-reasoning.git ~/.gemini/skills/evidence-aware-reasoning

# Claude Code Skill
git clone https://github.com/HaoNgo232/evidence-aware-reasoning.git ~/.claude/skills/evidence-aware-reasoning
```

---

## License

[MIT](../LICENSE)
