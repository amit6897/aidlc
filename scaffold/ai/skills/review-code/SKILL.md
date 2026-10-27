---
name: review-code
description: Review Java code for correctness, performance, security, and style
model: claude-sonnet-5-5
max_tokens: 4096
inputs:
  - file        # File path to review (optional if code is pasted inline)
  - code        # Inline code to review (optional if file path given)
  - focus       # Optional: specific concern to focus on (e.g. security, performance)
output: review
---

## Task
Review the following code and provide structured feedback.

## Code to Review
File: {{file}}

```java
{{code}}
```

## Focus Area (if specified)
{{focus}}

## Review Checklist
Evaluate and comment on each of the following dimensions:

### 1. Correctness
- Logic errors, edge cases not handled, null pointer risks

### 2. Design & Architecture
- Does it follow SOLID principles? Is it over-engineered or under-engineered?

### 3. Performance
- N+1 queries, unnecessary object creation, blocking calls, missing caching

### 4. Security
- Injection risks, improper input validation, exposed sensitive data

### 5. Spring Boot Specifics (if applicable)
- Improper use of annotations, transaction boundaries, bean scope issues

### 6. Code Style
- Naming, readability, Javadoc, unnecessary complexity

## Output Format
For each issue found:
- **Severity**: CRITICAL / MAJOR / MINOR / SUGGESTION
- **Location**: line or method name
- **Issue**: what is wrong
- **Fix**: what to do instead (with a code snippet if helpful)

End with a short **Summary** of the overall quality and the top 3 things to fix first.
