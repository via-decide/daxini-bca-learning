# Module 21: Security

## 1. Repository Context
- **Destination**: `docs/08-security-compliance/21-security/`
- **Files**: `index.md`, `security-section-1.md`, `security-section-2.md`, `security-section-3.md`, `security-section-4.md`
- **Navigation**: Module 21 in `08-security-compliance`
- **Sidebar**: "Security" with subsection pages for each major topic.
- **Cross-links**: prerequisites [8]; prerequisite for [46, 47, 78, 118]
- **Glossary entries**: 14 terms
- **Assets**: 4 Mermaid diagrams

## 2. Learning Objectives
- **Beginner Outcomes**: Define the module vocabulary, run the simplest safe workflow, and read existing project configuration.
- **Intermediate Outcomes**: Design repeatable workflows, compare common tools, and automate validation for team use.
- **Advanced Outcomes**: Operate the topic at production scale, handle failure modes, and document tradeoffs for architecture review.
- **Industry Readiness**: Apply these patterns in code review, CI/CD, incident response, and platform governance.

## 3. Prerequisites
- Module 8

## 4. Required Chapter Structure
### Security Section 1
- **Purpose**: Teach security section 1 with professional context and runnable examples.
- **Concepts**: Confidentiality, Integrity, Availability, Threat models
- **Examples required**: 3
- **Diagrams required**: 1

### Security Section 2
- **Purpose**: Teach security section 2 with professional context and runnable examples.
- **Concepts**: Encryption, Hashing, Digital signatures, Key management
- **Examples required**: 2
- **Diagrams required**: 1

### Security Section 3
- **Purpose**: Teach security section 3 with professional context and runnable examples.
- **Concepts**: Firewalls, OWASP Top 10, SQL injection, XSS
- **Examples required**: 2
- **Diagrams required**: 1

### Security Section 4
- **Purpose**: Teach security section 4 with professional context and runnable examples.
- **Concepts**: GDPR, SOC 2
- **Examples required**: 2
- **Diagrams required**: 1

## 5. Mandatory Concepts
- Availability
- Confidentiality
- Digital signatures
- Encryption
- Firewalls
- GDPR
- Hashing
- Integrity
- Key management
- OWASP Top 10
- SOC 2
- SQL injection
- Threat models
- XSS

## 6. Internal Knowledge Graph
```text
Prerequisites: [8]
Depends on: []
Prerequisite for: [46, 47, 78, 118]
Related: [8, 46, 47, 78, 118]
```

## 7. Required Diagrams
- `security-1.mmd`: Diagram for Security Section 1.
- `security-2.mmd`: Diagram for Security Section 2.
- `security-3.mmd`: Diagram for Security Section 3.
- `security-4.mmd`: Diagram for Security Section 4.

## 8. Practical Examples
- **Beginner Examples**: setup, inspect defaults, run a minimal workflow, verify output, document assumptions.
- **Production Examples**: automate checks, manage secrets/configuration, add rollback paths, monitor health, review security.
- **Enterprise Examples**: standardize policy, scale across teams, integrate private infrastructure, audit changes, plan migration.

## 9. Required Code
- Provide at least 9 examples across shell scripts, configuration files, and language-specific snippets.
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
- Availability
- Confidentiality
- Digital signatures
- Encryption
- Firewalls
- GDPR
- Hashing
- Integrity
- Key management
- OWASP Top 10
- SOC 2
- SQL injection
- Threat models
- XSS

## 12. Cross References
| Related Module | Why |
|---|---|
| Module 8 | Dependency or downstream relationship. |
| Module 46 | Dependency or downstream relationship. |
| Module 47 | Dependency or downstream relationship. |
| Module 78 | Dependency or downstream relationship. |
| Module 118 | Dependency or downstream relationship. |

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
