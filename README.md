# AIDLC — AI Development Life Cycle

> A portable AI harness that brings Claude-powered assistance to every phase of your development workflow.

AIDLC mirrors the SDLC with AI-assisted phases. Drop it into any project and get instant access to skills for capturing requirements, implementing features, reviewing code, writing tests, and generating documentation — all powered by the Claude API.

---

## How It Works

```
aidlc/ (this repo)          your-project/
     │                            │
     │  install.sh   ──────►  ai/
     │                        ├── rules/          ← your project context
     │                        └── skills/         ← AI capabilities
     │                            ├── implement/
     │                            ├── review-code/
     │                            ├── write-tests/
     │                            └── ...
     │
     └── core/               ← the runtime engine (stays here)
         ├── claude/         ← Anthropic API wrapper
         └── engine/         ← skill runner + rules merger
```

1. **Clone** this repo once on your machine
2. **Run** `install.sh` from any project root — it copies the `ai/` scaffold in
3. **Edit** `ai/rules/project-context.md` with your project's tech stack and conventions
4. **Run** skills from your project: `./aidlc run implement --requirement "..."`

---

## Prerequisites

- Bash 4.0+ (Linux / macOS / WSL on Windows)
- `curl`
- `python3`
- An [Anthropic API key](https://console.anthropic.com/)

---

## Installation

### 1. Clone the harness (once per machine)

```bash
git clone https://github.com/amit6897/aidlc.git ~/tools/aidlc
```

### 2. Install into any project

```bash
cd /path/to/your-project
~/tools/aidlc/install.sh
```

This scaffolds the following into your project:

```
your-project/
├── ai/
│   ├── agents/                        # multi-skill orchestrators (coming soon)
│   ├── rules/
│   │   └── project-context.md         # ← fill this in
│   └── skills/
│       ├── implement/SKILL.md
│       ├── review-code/SKILL.md
│       ├── capture-requirement/SKILL.md
│       ├── write-tests/SKILL.md
│       └── document/SKILL.md
└── aidlc                              # local entrypoint (auto-generated)
```

### 3. Set your API key

```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

### 4. Fill in your project context

Edit `ai/rules/project-context.md` — this is injected into every skill prompt so Claude always knows what it's working on.

---

## Usage

```bash
# Capture a rough idea as a structured requirement
./aidlc run capture-requirement --idea "Users should be able to reset their password via email"

# Implement a feature
./aidlc run implement --requirement "Add a UserService with CRUD operations for the User entity"

# Review code
./aidlc run review-code --file src/main/java/UserService.java \
  --code "$(cat src/main/java/UserService.java)"

# Write tests
./aidlc run write-tests --code "$(cat src/main/java/UserService.java)" --type unit

# Generate documentation
./aidlc run document --code "$(cat src/main/java/UserService.java)" --type javadoc

# List available skills
./aidlc list

# Check harness version
./aidlc version
```

---

## AIDLC Skills → SDLC Phases

| SDLC Phase     | AIDLC Skill             | What It Does                                      |
|----------------|-------------------------|---------------------------------------------------|
| Requirements   | `capture-requirement`   | Turns a rough idea into a developer-ready spec    |
| Implementation | `implement`             | Writes production Java code from a requirement    |
| Code Review    | `review-code`           | Reviews code for correctness, security, and style |
| Testing        | `write-tests`           | Generates JUnit 5 unit and integration tests      |
| Documentation  | `document`              | Produces Javadoc, README sections, or API docs    |

---

## Writing a Custom Skill

Create a folder under `ai/skills/` in your project:

```
ai/skills/my-skill/SKILL.md
```

```markdown
---
name: my-skill
description: One-line description shown in ./aidlc list
model: claude-sonnet-5-5
max_tokens: 2048
inputs:
  - param1    # required
  - param2    # optional
output: text
---

## Task
Do something with {{param1}}.

## Extra context
{{param2}}
```

Run it:

```bash
./aidlc run my-skill --param1 "some value" --param2 "optional context"
```

See [guides/writing-a-skill.md](guides/writing-a-skill.md) for full details.

---

## How Rules Work

Every `.md` file in `ai/rules/` is automatically prepended to the system prompt of every skill run. Use rules to define:

- Tech stack and architecture
- Coding conventions and style guide
- Domain vocabulary and key business rules

Rules are **global** — they apply to all skills. Keep them concise and project-specific.

---

## Repo Structure

```
aidlc/
├── core/
│   ├── claude/
│   │   └── client.sh          # Anthropic Messages API wrapper
│   └── engine/
│       ├── skill-runner.sh    # Orchestrates a skill run end-to-end
│       └── rules-merger.sh    # Prepends ai/rules/ to every prompt
│
├── scaffold/                  # Copied into target projects on install
│   └── ai/
│       ├── agents/
│       ├── rules/
│       │   └── project-context.md
│       └── skills/
│           ├── implement/SKILL.md
│           ├── review-code/SKILL.md
│           ├── capture-requirement/SKILL.md
│           ├── write-tests/SKILL.md
│           └── document/SKILL.md
│
├── guides/                    # Developer documentation
├── migrate/                   # Version upgrade scripts
├── tests/                     # Harness self-tests
├── install.sh                 # Project integration script
├── DESIGN.md                  # Architecture decisions
├── GUIDE.md                   # Full developer guide
└── VERSION                    # Current harness version (semver)
```

---

## Roadmap

- [x] Core skill engine (skill-runner, rules-merger, Claude client)
- [x] Default skills (implement, review-code, capture-requirement, write-tests, document)
- [x] Project install via `install.sh`
- [ ] Streaming output from Claude API
- [ ] Agent support — chain multiple skills in sequence
- [ ] `aidlc upgrade` command
- [ ] Java SDK wrapper for programmatic use in Spring Boot apps
- [ ] Multi-provider support (OpenAI, Gemini)

---

## License

MIT
