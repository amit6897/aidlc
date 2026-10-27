# AIDLC — Design Document

## Overview

AIDLC (AI Development Life Cycle) is a portable AI harness that mirrors the SDLC
with AI-assisted phases. It consists of a standalone repo that scaffolds an `ai/`
folder into any target project, providing a consistent structure for agents, rules,
and skills powered by the Claude API.

---

## Goals

- **Portable** — works with any project regardless of language or framework
- **Simple** — shell scripts, no build step, zero framework dependencies
- **Extensible** — easy to add new skills, rules, and (eventually) agents
- **Composable** — rules apply globally; skills can be chained by agents

---

## Architecture

```
aidlc/ (this repo)
├── core/                  ← The runtime engine
│   ├── claude/client.sh   ← Anthropic API wrapper
│   └── engine/
│       ├── skill-runner.sh   ← Orchestrates a skill run
│       └── rules-merger.sh   ← Prepends rules/ to every prompt
│
├── scaffold/              ← Copied into target projects on install
│   └── ai/
│       ├── agents/        ← Multi-skill orchestrators (future)
│       ├── rules/         ← Project-wide context injected into every skill
│       └── skills/        ← Individual AI capabilities
│           └── <name>/SKILL.md
│
├── guides/                ← Human-readable docs
├── migrate/               ← Upgrade scripts between harness versions
├── tests/                 ← Self-tests for the harness
├── install.sh             ← Entry point: copies scaffold into target project
└── VERSION                ← Harness version (semver)
```

---

## Key Concepts

### Skills
A skill is a named, reusable AI capability. Each skill lives in
`ai/skills/<name>/SKILL.md` and has:

- **Frontmatter** (YAML between `---` delimiters): metadata like `model`,
  `max_tokens`, `description`, and declared `inputs`
- **Prompt body**: the system/user prompt template with `{{variable}}`
  placeholders for runtime input injection

### Rules
Files in `ai/rules/*.md` are global constraints and context that are
prepended to the system prompt of every skill run. Use them for:
- Project tech stack and architecture
- Coding conventions and style guide
- Domain vocabulary and business rules

### Agents (Future)
Agents in `ai/agents/*.md` will orchestrate multiple skills in sequence
to complete a higher-level task (e.g., "implement feature" = capture-requirement
→ implement → write-tests → review-code → document).

---

## Skill Execution Flow

```
./aidlc run <skill> --param value
        │
        ▼
1. skill-runner.sh validates the skill exists
2. rules-merger.sh reads ai/rules/*.md → system preamble
3. SKILL.md frontmatter is parsed (model, max_tokens)
4. SKILL.md prompt body is parsed, {{params}} injected
5. claude/client.sh POSTs to Anthropic Messages API
6. Response streamed to stdout
```

---

## Design Decisions

| Decision | Choice | Reason |
|---|---|---|
| Runtime language | Bash | Zero dependencies, works everywhere |
| Skill format | Markdown + YAML frontmatter | Human-readable, easy to edit |
| AI provider | Anthropic Claude | Best reasoning for code tasks |
| Install method | Copy (not symlink) | Projects own their `ai/` folder |
| Prompt injection | `{{variable}}` | Simple, readable, no extra deps |

---

## Future Roadmap

- [ ] Agent support (multi-skill chaining)
- [ ] `aidlc upgrade` command (runs migrate/ scripts)
- [ ] Streaming output from Claude API
- [ ] Java SDK wrapper for programmatic use from Spring Boot apps
- [ ] Web UI for browsing and running skills
- [ ] Multi-provider support (OpenAI, Gemini)
