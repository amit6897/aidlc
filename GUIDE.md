# AIDLC — Developer Guide

## Prerequisites

- `bash` 4.0+
- `curl`
- `python3` (for JSON handling)
- An [Anthropic API key](https://console.anthropic.com/)

---

## Installation

### 1. Clone the harness (once per machine)

```bash
git clone https://github.com/amit6897/aidlc.git ~/tools/aidlc
```

### 2. Install into a project

```bash
cd /path/to/your-project
~/tools/aidlc/install.sh
```

This creates:
```
your-project/
├── ai/
│   ├── agents/
│   ├── rules/
│   │   └── project-context.md
│   └── skills/
│       ├── implement/SKILL.md
│       ├── review-code/SKILL.md
│       ├── capture-requirement/SKILL.md
│       ├── write-tests/SKILL.md
│       └── document/SKILL.md
└── aidlc          ← your local entrypoint
```

### 3. Export your API key

```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

Add this to your `~/.bashrc` or `~/.zshrc` to persist it.

### 4. Edit project context

Open `ai/rules/project-context.md` and fill in your project's tech stack,
architecture, and conventions. This context is injected into every skill run.

---

## Running Skills

```bash
# Implement a feature
./aidlc run implement --requirement "Add a UserService with CRUD operations"

# Review code
./aidlc run review-code --file src/main/java/UserService.java --code "$(cat src/main/java/UserService.java)"

# Capture a requirement
./aidlc run capture-requirement --idea "Users should be able to reset their password via email"

# Write tests
./aidlc run write-tests --code "$(cat src/main/java/UserService.java)" --type unit

# Generate documentation
./aidlc run document --code "$(cat src/main/java/UserService.java)" --type javadoc

# List all skills
./aidlc list

# Check version
./aidlc version
```

---

## Writing a Custom Skill

1. Create a folder under `ai/skills/`:
   ```bash
   mkdir ai/skills/my-skill
   ```

2. Create `ai/skills/my-skill/SKILL.md`:
   ```markdown
   ---
   name: my-skill
   description: What this skill does in one line
   model: claude-sonnet-5-5
   max_tokens: 2048
   inputs:
     - param1    # Description of param1
     - param2    # Description of param2 (optional)
   output: text
   ---

   ## Task
   Do something with {{param1}}.

   ## Additional context
   {{param2}}
   ```

3. Run it:
   ```bash
   ./aidlc run my-skill --param1 "some value" --param2 "optional"
   ```

---

## Tips

- **Rules are global** — anything in `ai/rules/*.md` is prepended to every skill.
  Keep rules concise and project-specific.
- **Skills are per-project** — after install, `ai/skills/` belongs to your project.
  Customize skills freely.
- **Pipe output** — redirect skill output to a file:
  ```bash
  ./aidlc run implement --requirement "..." > src/main/java/MyService.java
  ```
