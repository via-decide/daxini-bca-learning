# Module 13: Deployment

**Focus:** build artifacts, environment variables, Render/Vercel patterns, MongoDB Atlas, release checks.

This module keeps MERN learning-first: you study architecture and plans, then write your own implementation. It is not a complete application or code dump.

## Learning Objectives
- Explain the purpose of this topic before choosing tools or writing code.
- Draw the main data/control flow and identify boundaries between browser, server, and database.
- Create implementation plans using specifications, pseudocode, and checklists instead of copying solutions.
- Defend design decisions in project reviews and interviews.

## Prerequisites
- Read the repository Learning First philosophy and one existing project guide.
- Comfortable using a terminal, editor, browser devtools, and Git basics.
- Ability to write small programs independently from pseudocode.

## Core Concepts
- **Responsibility:** what this layer owns and what it must not own.
- **Inputs and outputs:** request data, user actions, stored records, and rendered feedback.
- **Failure modes:** invalid input, missing data, network errors, permissions, and deployment mismatch.
- **Contracts:** schemas, API shapes, UI states, and acceptance criteria.

## Architecture Diagrams

### Concept Map
```text
Student goal
   |
   v
Requirements -> Diagram -> Data/API contract -> Pseudocode -> Student-written code -> Tests -> Reflection
```

### MERN Placement
```text
[React UI] <-> [Express route + middleware] <-> [Service/controller decision] <-> [MongoDB/Mongoose model]
```

## Folder Structure
```text
project-name/
├── client/              # React interface planned by screens and components
│   ├── src/pages/       # route-level screens
│   ├── src/components/  # reusable UI pieces
│   └── src/services/    # API client functions, not business rules
├── server/              # Express API planned by resources
│   ├── src/routes/      # endpoint mapping
│   ├── src/controllers/ # request decisions
│   ├── src/models/      # MongoDB/Mongoose schemas
│   └── src/middleware/  # auth, validation, logging, error handling
└── docs/                # diagrams, API plan, database notes, test checklist
```

## Step-by-Step Implementation Roadmap
1. Write the user story and acceptance criteria in plain English.
2. Draw the request/data flow before selecting libraries.
3. Define data fields, API endpoints, UI states, and error cases.
4. Write pseudocode for each major action.
5. Implement the smallest vertical slice yourself.
6. Test success, failure, empty, unauthorized, and slow-network cases.
7. Refactor names and folder boundaries only after behavior is clear.

## Common Mistakes
- Starting with copied code before understanding the flow.
- Mixing UI state, API rules, and database rules in one place.
- Ignoring unhappy paths such as empty forms or expired tokens.
- Designing database fields only for the first screen instead of the project lifecycle.
- Treating deployment errors as mysteries instead of configuration mismatches.

## Debugging Checklist
- Can you reproduce the issue with exact steps?
- Which layer first shows incorrect behavior: UI, network, server, database, or deployment?
- What input was expected and what input actually arrived?
- What status code, console message, log entry, or database record proves the failure?
- Can a smaller isolated example reproduce the same problem?

## Interview Questions
- Explain the data flow for one feature without naming code files first.
- What responsibility belongs in the client, server, and database?
- How would you validate user input at multiple layers?
- What would break if two users performed the same action at the same time?
- How would you monitor this feature after deployment?

## Real-World Examples
- College portals use the same request lifecycle for login, attendance, marks, and notices.
- Booking systems combine UI state, availability checks, database consistency, and notification flows.
- Admin dashboards depend more on clean data models and filters than fancy components.

## Recommended Resources
- MDN Web Docs for browser, JavaScript, HTTP, and security fundamentals.
- MongoDB University for document modeling concepts.
- React and Express official documentation for framework mental models.
- OWASP Cheat Sheet Series for secure design checklists.

## Mini Exercises
- Draw the flow for one create/read/update/delete feature from click to database write.
- Convert a user story into an API endpoint table.
- List five validation rules and decide where each rule should run.
- Write pseudocode for handling an error without showing implementation code.

## Challenge Project
Design a small feature for a BCA project using this module. Submit only diagrams, endpoint plans, data fields, pseudocode, and testing notes before writing code.

## Further Reading
- HTTP semantics and status codes.
- Accessibility and progressive enhancement.
- Twelve-Factor App configuration principles.
- Secure coding and threat modeling introductions.
