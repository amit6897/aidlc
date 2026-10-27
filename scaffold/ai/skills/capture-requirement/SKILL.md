---
name: capture-requirement
description: Turn a rough idea or user story into a structured, developer-ready requirement
model: claude-sonnet-5-5
max_tokens: 2048
inputs:
  - idea        # The raw idea, user story, or feature description (required)
  - actor       # Who is the primary user/system performing the action (optional)
output: requirement
---

## Task
Take the following rough idea and convert it into a structured, developer-ready requirement document.

## Raw Idea
{{idea}}

## Primary Actor (if specified)
{{actor}}

## Output Format

### Feature Title
A concise name for this feature.

### Problem Statement
What problem does this solve? Why does it matter?

### User Stories
Write 2-5 user stories in the format:
> As a [actor], I want to [action] so that [benefit].

### Functional Requirements
Numbered list of concrete, testable requirements (FR-1, FR-2, ...).

### Non-Functional Requirements
Performance, security, scalability, availability constraints.

### Acceptance Criteria
Given/When/Then scenarios that define "done".

### Out of Scope
What this feature explicitly does NOT include.

### Open Questions
Any ambiguities that need clarification before development begins.
