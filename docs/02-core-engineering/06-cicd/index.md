# Module 6: CI/CD

## 1. Repository Context
- **Destination**: `docs/02-core-engineering/06-cicd/`
- **Files**: `index.md`, `cicd-fundamentals.md`, `github-actions.md`, `gitlab-ci.md`, `jenkins.md`, `pipeline-design.md`, `testing-automation.md`, `deployment-automation.md`
- **Navigation**: Module 6 in `02-core-engineering`
- **Sidebar**: "CI/CD" with subsection pages for each major topic.
- **Cross-links**: prerequisites [1, 2]; prerequisite for [3, 19, 20, 29, 30]
- **Glossary entries**: 28 terms
- **Assets**: 10 Mermaid diagrams

## 2. Learning Objectives
- **Beginner Outcomes**: Define the module vocabulary, run the simplest safe workflow, and read existing project configuration.
- **Intermediate Outcomes**: Design repeatable workflows, compare common tools, and automate validation for team use.
- **Advanced Outcomes**: Operate the topic at production scale, handle failure modes, and document tradeoffs for architecture review.
- **Industry Readiness**: Apply these patterns in code review, CI/CD, incident response, and platform governance.

## 3. Prerequisites
- Module 1
- Module 2

## 4. Required Chapter Structure
### CI/CD Fundamentals
- **Purpose**: Teach ci/cd fundamentals with professional context and runnable examples.
- **Concepts**: Continuous Integration, Continuous Deployment, Pipeline, Workflow, Artifacts
- **Examples required**: 3
- **Diagrams required**: 2

### GitHub Actions
- **Purpose**: Teach github actions with professional context and runnable examples.
- **Concepts**: Actions, Workflows, Jobs, Steps, Secrets
- **Examples required**: 4
- **Diagrams required**: 2

### Other CI/CD Platforms
- **Purpose**: Teach other ci/cd platforms with professional context and runnable examples.
- **Concepts**: GitLab CI, Jenkins, CircleCI, Travis CI
- **Examples required**: 4
- **Diagrams required**: 1

### Pipeline Design
- **Purpose**: Teach pipeline design with professional context and runnable examples.
- **Concepts**: Stages, Parallel execution, Conditional logic, Caching
- **Examples required**: 3
- **Diagrams required**: 2

### Testing in CI/CD
- **Purpose**: Teach testing in ci/cd with professional context and runnable examples.
- **Concepts**: Unit tests, Integration tests, E2E tests, Coverage
- **Examples required**: 3
- **Diagrams required**: 1

### Deployment Automation
- **Purpose**: Teach deployment automation with professional context and runnable examples.
- **Concepts**: Automated deployments, Environment promotion, Release automation
- **Examples required**: 3
- **Diagrams required**: 1

### Monitoring CI/CD Health
- **Purpose**: Teach monitoring ci/cd health with professional context and runnable examples.
- **Concepts**: Pipeline metrics, Failure analysis, Build performance
- **Examples required**: 2
- **Diagrams required**: 1

## 5. Mandatory Concepts
- Actions
- Artifacts
- Automated deployments
- Build performance
- Caching
- CircleCI
- Conditional logic
- Continuous Deployment
- Continuous Integration
- Coverage
- E2E tests
- Environment promotion
- Failure analysis
- GitLab CI
- Integration tests
- Jenkins
- Jobs
- Parallel execution
- Pipeline
- Pipeline metrics
- Release automation
- Secrets
- Stages
- Steps
- Travis CI
- Unit tests
- Workflow
- Workflows

## 6. Internal Knowledge Graph
```text
Prerequisites: [1, 2]
Depends on: []
Prerequisite for: [3, 19, 20, 29, 30]
Related: [1, 2, 3, 19, 20, 29, 30]
```

## 7. Required Diagrams
- `ci-cd-1.mmd`: Diagram for CI/CD Fundamentals.
- `ci-cd-2.mmd`: Diagram for GitHub Actions.
- `ci-cd-3.mmd`: Diagram for Other CI/CD Platforms.
- `ci-cd-4.mmd`: Diagram for Pipeline Design.
- `ci-cd-5.mmd`: Diagram for Testing in CI/CD.
- `ci-cd-6.mmd`: Diagram for Deployment Automation.
- `ci-cd-7.mmd`: Diagram for Monitoring CI/CD Health.

## 8. Practical Examples
- **Beginner Examples**: setup, inspect defaults, run a minimal workflow, verify output, document assumptions.
- **Production Examples**: automate checks, manage secrets/configuration, add rollback paths, monitor health, review security.
- **Enterprise Examples**: standardize policy, scale across teams, integrate private infrastructure, audit changes, plan migration.

## 9. Required Code
- Provide at least 22 examples across shell scripts, configuration files, and language-specific snippets.
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
- Actions
- Artifacts
- Automated deployments
- Build performance
- Caching
- CircleCI
- Conditional logic
- Continuous Deployment
- Continuous Integration
- Coverage
- E2E tests
- Environment promotion
- Failure analysis
- GitLab CI
- Integration tests
- Jenkins
- Jobs
- Parallel execution
- Pipeline
- Pipeline metrics
- Release automation
- Secrets
- Stages
- Steps
- Travis CI
- Unit tests
- Workflow
- Workflows

## 12. Cross References
| Related Module | Why |
|---|---|
| Module 1 | Dependency or downstream relationship. |
| Module 2 | Dependency or downstream relationship. |
| Module 3 | Dependency or downstream relationship. |
| Module 19 | Dependency or downstream relationship. |
| Module 20 | Dependency or downstream relationship. |
| Module 29 | Dependency or downstream relationship. |
| Module 30 | Dependency or downstream relationship. |

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
