---
name: document
description: Generate Javadoc, README sections, or API documentation for Java code
model: claude-sonnet-5-5
max_tokens: 3072
inputs:
  - code        # The Java class, method, or module to document (required)
  - type        # Output type: javadoc | readme | api (default: javadoc)
output: documentation
---

## Task
Generate documentation for the following Java code.

## Code
```java
{{code}}
```

## Documentation Type
{{type}}

## Instructions

### If type = javadoc
- Add Javadoc to every public class, constructor, method, and field
- Include @param, @return, @throws, @since tags
- Write clear, concise descriptions
- Return the fully documented Java file

### If type = readme
- Write a README section suitable for this class/module
- Include: Purpose, Usage Examples, Key Methods, Configuration (if any)
- Use Markdown with code blocks for examples

### If type = api
- Generate OpenAPI-style documentation if the code contains REST endpoints
- Include: endpoint path, method, request body schema, response schema, error codes
- Format as Markdown table + JSON schema snippets

Return clearly formatted output matching the requested type.
