# Module 9: APIs

## 1. Repository Context
- **Destination**: `docs/02-core-engineering/09-apis/`
- **Files**: `index.md`, `api-fundamentals.md`, `rest-apis.md`, `graphql.md`, `grpc.md`, `api-design.md`, `api-documentation.md`, `api-versioning.md`, `rate-limiting.md`
- **Navigation**: Module 9 in `02-core-engineering`
- **Sidebar**: "APIs" with subsection pages for each major topic.
- **Cross-links**: prerequisites [1, 10]; prerequisite for [7, 8, 16, 51, 112]
- **Glossary entries**: 27 terms
- **Assets**: 10 Mermaid diagrams

## 2. Learning Objectives
- **Beginner Outcomes**: Define the module vocabulary, run the simplest safe workflow, and read existing project configuration.
- **Intermediate Outcomes**: Design repeatable workflows, compare common tools, and automate validation for team use.
- **Advanced Outcomes**: Operate the topic at production scale, handle failure modes, and document tradeoffs for architecture review.
- **Industry Readiness**: Apply these patterns in code review, CI/CD, incident response, and platform governance.

## 3. Prerequisites
- Module 1
- Module 10

## 4. Required Chapter Structure
### API Fundamentals
- **Purpose**: Teach api fundamentals with professional context and runnable examples.
- **Concepts**: API, Endpoint, Request/Response, Status codes
- **Examples required**: 3
- **Diagrams required**: 2

### REST API Design
- **Purpose**: Teach rest api design with professional context and runnable examples.
- **Concepts**: REST, Resources, HTTP methods, Hypermedia
- **Examples required**: 5
- **Diagrams required**: 2

### GraphQL
- **Purpose**: Teach graphql with professional context and runnable examples.
- **Concepts**: GraphQL, Queries, Mutations, Subscriptions
- **Examples required**: 4
- **Diagrams required**: 1

### gRPC & Protobuf
- **Purpose**: Teach grpc & protobuf with professional context and runnable examples.
- **Concepts**: gRPC, Protocol Buffers, Streaming
- **Examples required**: 3
- **Diagrams required**: 1

### API Design Best Practices
- **Purpose**: Teach api design best practices with professional context and runnable examples.
- **Concepts**: Consistency, Error handling, Pagination, Filtering
- **Examples required**: 3
- **Diagrams required**: 1

### API Documentation
- **Purpose**: Teach api documentation with professional context and runnable examples.
- **Concepts**: OpenAPI/Swagger, API documentation tools, Interactive docs
- **Examples required**: 2
- **Diagrams required**: 1

### Versioning & Compatibility
- **Purpose**: Teach versioning & compatibility with professional context and runnable examples.
- **Concepts**: API versioning strategies, Backward compatibility
- **Examples required**: 2
- **Diagrams required**: 1

### Rate Limiting & Throttling
- **Purpose**: Teach rate limiting & throttling with professional context and runnable examples.
- **Concepts**: Rate limiting, Quota management, Throttling strategies
- **Examples required**: 2
- **Diagrams required**: 1

## 5. Mandatory Concepts
- API
- API documentation tools
- API versioning strategies
- Backward compatibility
- Consistency
- Endpoint
- Error handling
- Filtering
- GraphQL
- HTTP methods
- Hypermedia
- Interactive docs
- Mutations
- OpenAPI/Swagger
- Pagination
- Protocol Buffers
- Queries
- Quota management
- REST
- Rate limiting
- Request/Response
- Resources
- Status codes
- Streaming
- Subscriptions
- Throttling strategies
- gRPC

## 6. Internal Knowledge Graph
```text
Prerequisites: [1, 10]
Depends on: []
Prerequisite for: [7, 8, 16, 51, 112]
Related: [1, 7, 8, 10, 16, 51, 112]
```

## 7. Required Diagrams
- `apis-1.mmd`: Diagram for API Fundamentals.
- `apis-2.mmd`: Diagram for REST API Design.
- `apis-3.mmd`: Diagram for GraphQL.
- `apis-4.mmd`: Diagram for gRPC & Protobuf.
- `apis-5.mmd`: Diagram for API Design Best Practices.
- `apis-6.mmd`: Diagram for API Documentation.
- `apis-7.mmd`: Diagram for Versioning & Compatibility.
- `apis-8.mmd`: Diagram for Rate Limiting & Throttling.

## 8. Practical Examples
- **Beginner Examples**: setup, inspect defaults, run a minimal workflow, verify output, document assumptions.
- **Production Examples**: automate checks, manage secrets/configuration, add rollback paths, monitor health, review security.
- **Enterprise Examples**: standardize policy, scale across teams, integrate private infrastructure, audit changes, plan migration.

## 9. Required Code
- Provide at least 24 examples across shell scripts, configuration files, and language-specific snippets.
- Store reusable examples in `docs/_shared/code-examples/` using metadata comments and expected output.

## 10. Exercises
### Concept Questions
1. Define the three most important terms in this module.
2. Explain the safest production workflow.
3. Compare two tools or patterns from this module.
4. Identify one security risk and mitigation.
5. Describe how this module connects to a prerequisite.
6. Explain a common operational failure mode.

### Practical Exercises
1. Build a minimal local example.
2. Add automated validation.
3. Document setup and expected output.
4. Integrate the workflow into CI/CD.
5. Perform a safe rollback or recovery.

### Debugging Exercises
1. Diagnose a configuration error.
2. Resolve a dependency or network failure.
3. Fix an authentication or permission issue.
4. Restore from a broken deployment or state.
5. Improve performance after measuring a bottleneck.

## 11. Glossary Requirements
- API
- API documentation tools
- API versioning strategies
- Backward compatibility
- Consistency
- Endpoint
- Error handling
- Filtering
- GraphQL
- HTTP methods
- Hypermedia
- Interactive docs
- Mutations
- OpenAPI/Swagger
- Pagination
- Protocol Buffers
- Queries
- Quota management
- REST
- Rate limiting
- Request/Response
- Resources
- Status codes
- Streaming
- Subscriptions
- Throttling strategies
- gRPC

## 12. Cross References
| Related Module | Why |
|---|---|
| Module 1 | Dependency or downstream relationship. |
| Module 7 | Dependency or downstream relationship. |
| Module 8 | Dependency or downstream relationship. |
| Module 10 | Dependency or downstream relationship. |
| Module 16 | Dependency or downstream relationship. |
| Module 51 | Dependency or downstream relationship. |
| Module 112 | Dependency or downstream relationship. |

## 13. Documentation Constraints
- Use second person and action-oriented instructions.
- Specify a language for every code block.
- Include warnings for destructive or production-risk operations.
- Prefer tables for comparisons and Mermaid for architecture diagrams.

## 14. Acceptance Criteria
- [ ] All required files exist.
- [ ] All mandatory concepts are explained with examples.
- [ ] Required diagrams are created and embedded.
- [ ] Code examples include setup, expected output, and production notes.
- [ ] Exercises cover concept, practical, and debugging skills.
- [ ] Cross-references and glossary links resolve.
