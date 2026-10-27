---
name: implement
description: Implement a Java class or feature from a plain-language requirement
model: claude-sonnet-5-5
max_tokens: 4096
inputs:
  - requirement   # What to build (required)
  - context       # Existing code or additional notes (optional)
output: code
---

## Task
Implement the following requirement:

{{requirement}}

## Additional Context
{{context}}

## Instructions
- Write idiomatic, production-ready Java code
- Follow the project conventions defined in the rules
- Include all necessary imports
- Add Javadoc to public classes and methods
- If creating a Spring Boot component, use appropriate annotations (@Service, @Repository, @RestController, etc.)
- Return the full file path and complete file content for each file you create or modify
- If you need to create multiple files, clearly separate them with a header like: `### File: src/main/java/...`
