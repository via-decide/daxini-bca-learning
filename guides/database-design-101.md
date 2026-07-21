# Database Design 101

Databases preserve the facts a system depends on. Good database design makes data accurate, queryable, recoverable, and meaningful over time.

## Core Concepts

- Entity: a thing the system stores, such as user, order, note, or payment.
- Attribute: a property of an entity.
- Relationship: how entities connect.
- Constraint: a rule the database protects.
- Index: a structure that improves lookup speed at write and storage cost.

## Design Workflow

1. Extract nouns and events from requirements.
2. Decide which facts must be permanent.
3. Model relationships and ownership.
4. Add constraints for correctness.
5. Plan indexes from expected queries.
6. Review privacy, backups, and retention.

```mermaid
erDiagram
  USER ||--o{ PROJECT : owns
  PROJECT ||--o{ TASK : contains
  TASK }o--|| STATUS : has
```

## Trade-offs

Normalized schemas reduce duplication but can require joins. Denormalized schemas simplify reads but create update consistency risk. Choose based on correctness first, then performance evidence.

## Common Mistakes

- Designing tables from UI screens only.
- Storing passwords, tokens, or private data carelessly.
- Forgetting unique constraints and foreign keys.
- Adding indexes without knowing query patterns.

## Further Reading

- [Databases & Storage](../learning-tracks/developer-ecosystem/modules/11-databases-storage.md)
- [Best Practices](../resources/BEST_PRACTICES.md)

