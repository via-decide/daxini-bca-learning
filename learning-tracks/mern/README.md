# MERN Stack Learning Track

This track adds a structured MERN curriculum alongside the existing BCA project guides. It does **not** replace the repository philosophy, directories, or project content. Students use it to gain full-stack architectural understanding before or alongside project implementation.

## How to Use This Track
1. Study one module at a time.
2. Produce diagrams, API plans, schema notes, and pseudocode.
3. Build your own code only after your plan can be explained.
4. Map the chosen BCA project to the required modules.

## Module Sequence
| Module | Topic |
|---|---|
| 01 | HTML, CSS, and Browser JavaScript |
| 02 | Modern JavaScript |
| 03 | Node.js |
| 04 | Express |
| 05 | REST APIs |
| 06 | MongoDB |
| 07 | Mongoose |
| 08 | Authentication |
| 09 | React |
| 10 | React Router |
| 11 | State Management |
| 12 | Full-Stack Project Planning |
| 13 | Deployment |
| 14 | Security |
| 15 | Industry Best Practices |

## Architecture Guides

### Client-Server Architecture
```text
User -> Browser/React -> HTTP request -> Express server -> MongoDB -> Express response -> React render
```
The client owns interaction and presentation. The server owns trusted business decisions. The database owns durable records.

### HTTP Request Lifecycle
```text
Click/Form -> Validate UI -> Build request -> Network -> Route -> Middleware -> Controller -> Model -> Response -> UI state
```

### REST APIs
```text
Resource: /students
GET list | POST create | GET /:id detail | PATCH /:id change | DELETE /:id remove
```

### MVC Pattern
```text
Model: data rules <-> Controller: request decisions <-> View: React screen
```

### Authentication Flow, JWT, Sessions, and Cookies
```text
Login form -> Server verifies password -> Issues session id or JWT -> Browser stores approved credential -> Protected request -> Middleware verifies -> Controller runs
```
Use diagrams to compare token storage, cookie attributes, expiry, refresh, logout, and role checks before coding.

### Middleware
```text
Request -> logging -> parsing -> auth -> validation -> route handler -> error handler -> response
```

### Database Relationships
```text
One-to-many: User -> Orders
Many-to-many: Student <-> Courses through Enrollments
Embedded: Order -> LineItems when read together
Referenced: User id in Posts when reused independently
```

### CRUD Operations
```text
Create -> Validate -> Insert -> Confirm
Read -> Filter -> Sort/Page -> Return
Update -> Authorize -> Validate changes -> Save
Delete -> Authorize -> Soft-delete or remove -> Audit
```

### File Uploads
```text
Select file -> Client preview -> Multipart request -> Server size/type check -> Storage -> Metadata record -> Download URL
```

### Error Handling, Validation, and Logging
```text
Bad input -> 400 validation response
Unauthenticated -> 401
Forbidden role -> 403
Missing record -> 404
Unexpected failure -> log correlation id -> 500 safe message
```

## Backend Design Exercises (No Solutions)
- Design an authentication system with signup, login, logout, password reset, and account lockout rules.
- Design a REST API for a library, gym, hospital, or student portal.
- Design a role-based permission system for student, staff, admin, and owner roles.
- Design a student progress database for courses, lessons, quizzes, and certificates.
- Design an upload service for profile photos and documents.
- Design an admin dashboard with filters, charts, exports, and audit history.
- Design a notification service for email, SMS, and in-app alerts.

## Interview Preparation Themes
- Node.js event loop, modules, npm, process environment, and asynchronous errors.
- Express routing, middleware order, validation, controllers, and centralized error handling.
- MongoDB document modeling, indexes, aggregation, embedding vs referencing.
- React components, state, effects, forms, routing, and performance tradeoffs.
- REST API resource naming, status codes, pagination, versioning, and idempotency.
- Authentication with JWT, sessions, cookies, password hashing, and role checks.
- Security with CORS, rate limiting, injection prevention, headers, secrets, and logging.
- Deployment with environment variables, builds, database connection strings, domains, and rollback plans.
- Backend architecture, scalability, caching, queues, observability, and performance measurement.

## Project Mapping
See [`project-mapping.md`](./project-mapping.md) for MERN recommendations for all 120 indexed BCA projects.
