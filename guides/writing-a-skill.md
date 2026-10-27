# Writing a Custom Skill

## Skill File Structure

Every skill lives at `ai/skills/<name>/SKILL.md` and has two parts:

### 1. Frontmatter (YAML)

```yaml
---
name: my-skill
description: One-line description shown in `./aidlc list`
model: claude-sonnet-5-5
max_tokens: 2048
inputs:
  - param1     # required
  - param2     # optional
output: code   # code | text | review | documentation
---
```

### 2. Prompt Body

Everything below the closing `---` is the prompt template.
Use `{{param_name}}` to inject runtime inputs:

```
## Task
Implement {{param1}} following the project conventions.

## Extra context
{{param2}}
```

## Input Injection

Inputs are passed as `--key value` flags:

```bash
./aidlc run my-skill --param1 "Hello" --param2 "World"
```

`{{param1}}` → `Hello`, `{{param2}}` → `World`

## Best Practices

- Keep the prompt body focused — Claude works best with clear, single-purpose prompts
- Use `ai/rules/` for context that applies to ALL skills (tech stack, conventions)
- Use the skill's prompt body for context specific to that skill
- Declare all expected inputs in the frontmatter for documentation purposes
- Match `model` to task complexity: lighter models for quick tasks, Sonnet/Opus for complex ones
