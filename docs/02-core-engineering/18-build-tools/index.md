# Module 18: Build Tools

## 1. Repository Context
- **Destination**: `docs/02-core-engineering/18-build-tools/`
- **Files**: `index.md`, `build-tools-section-1.md`, `build-tools-section-2.md`, `build-tools-section-3.md`
- **Navigation**: Module 18 in `02-core-engineering`
- **Sidebar**: "Build Tools" with subsection pages for each major topic.
- **Cross-links**: prerequisites [2, 6]; prerequisite for [29, 30, 38]
- **Glossary entries**: 11 terms
- **Assets**: 3 Mermaid diagrams

## 2. Learning Objectives
- **Beginner Outcomes**: Define the module vocabulary, run the simplest safe workflow, and read existing project configuration.
- **Intermediate Outcomes**: Design repeatable workflows, compare common tools, and automate validation for team use.
- **Advanced Outcomes**: Operate the topic at production scale, handle failure modes, and document tradeoffs for architecture review.
- **Industry Readiness**: Apply these patterns in code review, CI/CD, incident response, and platform governance.

## 3. Prerequisites
- Module 2
- Module 6

## 4. Required Chapter Structure
### Build Tools Section 1
- **Purpose**: Teach build tools section 1 with professional context and runnable examples.
- **Concepts**: Build process, Bundling, Transpilation, Optimization
- **Examples required**: 3
- **Diagrams required**: 1

### Build Tools Section 2
- **Purpose**: Teach build tools section 2 with professional context and runnable examples.
- **Concepts**: Webpack, Vite, Parcel, esbuild
- **Examples required**: 2
- **Diagrams required**: 1

### Build Tools Section 3
- **Purpose**: Teach build tools section 3 with professional context and runnable examples.
- **Concepts**: Maven, Gradle, Incremental builds
- **Examples required**: 2
- **Diagrams required**: 1

## 5. Mandatory Concepts
- Build process
- Bundling
- Gradle
- Incremental builds
- Maven
- Optimization
- Parcel
- Transpilation
- Vite
- Webpack
- esbuild

## 6. Internal Knowledge Graph
```text
Prerequisites: [2, 6]
Depends on: []
Prerequisite for: [29, 30, 38]
Related: [2, 6, 29, 30, 38]
```

## 7. Required Diagrams
- `build-tools-1.mmd`: Diagram for Build Tools Section 1.
- `build-tools-2.mmd`: Diagram for Build Tools Section 2.
- `build-tools-3.mmd`: Diagram for Build Tools Section 3.

## 8. Practical Examples
- **Beginner Examples**: setup, inspect defaults, run a minimal workflow, verify output, document assumptions.
- **Production Examples**: automate checks, manage secrets/configuration, add rollback paths, monitor health, review security.
- **Enterprise Examples**: standardize policy, scale across teams, integrate private infrastructure, audit changes, plan migration.

## 9. Required Code
- Provide at least 7 examples across shell scripts, configuration files, and language-specific snippets.
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
- Build process
- Bundling
- Gradle
- Incremental builds
- Maven
- Optimization
- Parcel
- Transpilation
- Vite
- Webpack
- esbuild

## 12. Cross References
| Related Module | Why |
|---|---|
| Module 2 | Dependency or downstream relationship. |
| Module 6 | Dependency or downstream relationship. |
| Module 29 | Dependency or downstream relationship. |
| Module 30 | Dependency or downstream relationship. |
| Module 38 | Dependency or downstream relationship. |

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
