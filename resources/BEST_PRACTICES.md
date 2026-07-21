# Best Practices

Best practices are reusable habits that reduce bugs, confusion, security risk, and maintenance cost. They are not rules to memorize; they are defaults to question when requirements change.

## Engineering Defaults

- Understand requirements before choosing tools.
- Keep code, documentation, and diagrams consistent.
- Validate untrusted input.
- Store secrets outside Git.
- Prefer small, reversible changes.
- Test behavior, not implementation details.
- Log enough to debug without exposing private data.

## Architecture

Separate user interface, business rules, data access, and operational concerns. This keeps changes local and makes failures easier to diagnose.

## Business Perspective

Good practices lower support cost and increase trust. They also make projects easier to demonstrate, maintain, and hand over to another developer.

## Further Reading

- [How to Think Like a Developer](../guides/how-to-think-like-developer.md)
- [Production Readiness](../learning-tracks/developer-ecosystem/modules/33-production-readiness.md)

