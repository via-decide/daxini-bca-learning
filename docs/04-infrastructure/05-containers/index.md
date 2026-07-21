# Module 5: Containers

## 1. Repository Context
- **Destination**: `docs/04-infrastructure/05-containers/`
- **Files**: `index.md`, `container-fundamentals.md`, `docker-essentials.md`, `dockerfile-optimization.md`, `container-networking.md`, `container-orchestration-intro.md`, `container-security.md`
- **Navigation**: Module 5 in `04-infrastructure`
- **Sidebar**: "Containers" with subsection pages for each major topic.
- **Cross-links**: prerequisites [1, 2]; prerequisite for [3, 6, 19, 20, 40, 82]
- **Glossary entries**: 24 terms
- **Assets**: 9 Mermaid diagrams

## 2. Learning Objectives
- **Beginner Outcomes**: Define the module vocabulary, run the simplest safe workflow, and read existing project configuration.
- **Intermediate Outcomes**: Design repeatable workflows, compare common tools, and automate validation for team use.
- **Advanced Outcomes**: Operate the topic at production scale, handle failure modes, and document tradeoffs for architecture review.
- **Industry Readiness**: Apply these patterns in code review, CI/CD, incident response, and platform governance.

## 3. Prerequisites
- Module 1
- Module 2

## 4. Required Chapter Structure
### Container Fundamentals
- **Purpose**: Teach container fundamentals with professional context and runnable examples.
- **Concepts**: Container, Image, Layer, Registry, Namespace, Cgroup
- **Examples required**: 3
- **Diagrams required**: 2

### Docker Essentials
- **Purpose**: Teach docker essentials with professional context and runnable examples.
- **Concepts**: Docker, Docker daemon, Container lifecycle, Port mapping
- **Examples required**: 4
- **Diagrams required**: 2

### Dockerfile & Image Building
- **Purpose**: Teach dockerfile & image building with professional context and runnable examples.
- **Concepts**: Dockerfile, Image layers, Build optimization, Multi-stage builds
- **Examples required**: 5
- **Diagrams required**: 1

### Container Networking
- **Purpose**: Teach container networking with professional context and runnable examples.
- **Concepts**: Bridge network, Host network, Overlay network, DNS
- **Examples required**: 3
- **Diagrams required**: 2

### Container Orchestration Intro
- **Purpose**: Teach container orchestration intro with professional context and runnable examples.
- **Concepts**: Orchestration, Kubernetes intro, Docker Swarm
- **Examples required**: 2
- **Diagrams required**: 1

### Container Security
- **Purpose**: Teach container security with professional context and runnable examples.
- **Concepts**: Image scanning, Registry security, Runtime security
- **Examples required**: 3
- **Diagrams required**: 1

## 5. Mandatory Concepts
- Bridge network
- Build optimization
- Cgroup
- Container
- Container lifecycle
- DNS
- Docker
- Docker Swarm
- Docker daemon
- Dockerfile
- Host network
- Image
- Image layers
- Image scanning
- Kubernetes intro
- Layer
- Multi-stage builds
- Namespace
- Orchestration
- Overlay network
- Port mapping
- Registry
- Registry security
- Runtime security

## 6. Internal Knowledge Graph
```text
Prerequisites: [1, 2]
Depends on: []
Prerequisite for: [3, 6, 19, 20, 40, 82]
Related: [1, 2, 3, 6, 19, 20, 40, 82]
```

## 7. Required Diagrams
- `containers-1.mmd`: Diagram for Container Fundamentals.
- `containers-2.mmd`: Diagram for Docker Essentials.
- `containers-3.mmd`: Diagram for Dockerfile & Image Building.
- `containers-4.mmd`: Diagram for Container Networking.
- `containers-5.mmd`: Diagram for Container Orchestration Intro.
- `containers-6.mmd`: Diagram for Container Security.

## 8. Practical Examples
- **Beginner Examples**: setup, inspect defaults, run a minimal workflow, verify output, document assumptions.
- **Production Examples**: automate checks, manage secrets/configuration, add rollback paths, monitor health, review security.
- **Enterprise Examples**: standardize policy, scale across teams, integrate private infrastructure, audit changes, plan migration.

## 9. Required Code
- Provide at least 20 examples across shell scripts, configuration files, and language-specific snippets.
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
- Bridge network
- Build optimization
- Cgroup
- Container
- Container lifecycle
- DNS
- Docker
- Docker Swarm
- Docker daemon
- Dockerfile
- Host network
- Image
- Image layers
- Image scanning
- Kubernetes intro
- Layer
- Multi-stage builds
- Namespace
- Orchestration
- Overlay network
- Port mapping
- Registry
- Registry security
- Runtime security

## 12. Cross References
| Related Module | Why |
|---|---|
| Module 1 | Dependency or downstream relationship. |
| Module 2 | Dependency or downstream relationship. |
| Module 3 | Dependency or downstream relationship. |
| Module 6 | Dependency or downstream relationship. |
| Module 19 | Dependency or downstream relationship. |
| Module 20 | Dependency or downstream relationship. |
| Module 40 | Dependency or downstream relationship. |
| Module 82 | Dependency or downstream relationship. |

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
