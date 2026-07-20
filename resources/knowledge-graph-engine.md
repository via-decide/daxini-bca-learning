# BCA Knowledge Graph Engine

The knowledge graph engine turns the repository into a deterministic learning operating system. It indexes repository assets, validates canonical topic metadata, generates graph relationships, and exports learning paths for students, exam revision, interviews, industry skills, project recommendations, and future AI tutoring.

## Canonical Inputs

```text
Repository markdown/PDF/images/PPT/code/labs/papers/syllabus
        +
data/knowledge-topics.json canonical topic metadata
        |
        v
scripts/generate-knowledge-graph.js
        |
        v
knowledge-index.json + knowledge-graph.json + visualization + report
```

## Metadata Schema

Every topic in `data/knowledge-topics.json` must include:

- Unique ID
- Subject
- Semester
- Unit
- Difficulty
- Learning Time
- Prerequisites
- Concepts Required
- Concepts Enabled
- Practical Applications
- Industry Usage
- Interview Frequency
- Exam Frequency
- Important Formulae
- Algorithms
- Common Mistakes
- Related Experiments
- Programming Examples
- External References
- Revision Priority
- Tags

## Generated Actions

The generator implements these deterministic actions:

1. Builds `knowledge-index.json`.
2. Builds `knowledge-graph.json`.
3. Generates dependency graph edges.
4. Generates topic relationships from prerequisites, enabled concepts, required concepts, and repository asset matches.
5. Validates prerequisites.
6. Generates a semester-aware learning path.
7. Generates an exam revision path.
8. Generates an interview preparation path.
9. Generates an industry skill path.
10. Exports a concept search index.
11. Reports missing physical assets as dead links.
12. Detects duplicate topic titles.
13. Detects missing required topic fields.
14. Computes topic completeness scores.
15. Exports `knowledge-graph-visualization.json` for graph visualizers.

## Core Dependency Spine

```text
Programming Fundamentals
        ↓
Data Structures
        ↓
Algorithms
        ↓
Operating Systems
        ↓
Computer Networks
        ↓
Distributed Systems
```

## Cross-Semester Concept Example

```text
Binary Trees
  ├─ Compiler Design: parse trees and syntax trees
  ├─ Databases: B-tree/B+tree index reasoning
  ├─ Operating Systems: directory trees and file systems
  ├─ AI Search: BFS/DFS/search spaces
  └─ Project Development: efficient search and hierarchy features
```

## Commands

```bash
npm run knowledge:generate
npm run knowledge:check
```

Use `knowledge:generate` after adding syllabus topics, lab manuals, practicals, previous-year papers, project guides, or code examples. Use `knowledge:check` before committing to ensure prerequisites are valid and the graph has no orphan topics.

## Learning-First Boundary

This engine does not provide solved assignments or production applications. It provides deterministic structure: metadata, relationships, paths, validation, search indexes, and graph exports so students can understand what to learn, why it matters, and where it is used.
