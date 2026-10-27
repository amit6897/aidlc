---
name: write-tests
description: Generate JUnit 5 unit and integration tests for a given Java class or method
model: claude-sonnet-5-5
max_tokens: 4096
inputs:
  - code        # The Java class or method to test (required)
  - type        # Test type: unit | integration | both (default: unit)
  - focus       # Optional: specific method or behaviour to focus on
output: code
---

## Task
Write comprehensive tests for the following Java code.

## Code Under Test
```java
{{code}}
```

## Test Type
{{type}}

## Focus (if specified)
{{focus}}

## Instructions

### For Unit Tests
- Use JUnit 5 (@Test, @BeforeEach, @ExtendWith)
- Mock dependencies with Mockito (@Mock, @InjectMocks, when/thenReturn)
- Cover: happy path, edge cases, null inputs, boundary values, exception scenarios
- Use AssertJ for fluent assertions
- Name tests clearly: `methodName_scenario_expectedBehaviour()`

### For Integration Tests
- Use @SpringBootTest or @WebMvcTest / @DataJpaTest as appropriate
- Use @MockBean for external dependencies
- Test the full slice (controller -> service -> repository)

### Output Format
Return complete, compilable test files with:
- Full package declaration and imports
- One test class per production class
- File path header: `### File: src/test/java/...`
- Comments explaining non-obvious test cases
