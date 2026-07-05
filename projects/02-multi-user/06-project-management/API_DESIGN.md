# 👔 Project Management System: API Design

**"Build a multi-user project board (like Jira or Trello) where Managers create projects, Assignees move tasks across columns, and Watchers receive updates, requiring complex multi-table relationships."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Project Management:**
```
POST   /api/projects           → Create a new project (You become the 'owner')
GET    /api/projects           → List projects you own or are assigned tickets in
GET    /api/projects/:id       → Get project details (includes all tickets)
DELETE /api/projects/:id       → Delete project (Must be owner. Cascades down.)
```

**Ticket Management:**
```
POST   /api/projects/:pid/tickets → Create a ticket in a project
PUT    /api/tickets/:id           → Update a ticket (e.g., change status, change assignee)
```

**Collaboration:**
```
POST   /api/tickets/:tid/comments → Add a comment to a ticket
GET    /api/tickets/:tid/comments → Get all comments for a ticket
```

---

## 📦 Request/Response Examples

### 1. Create a Ticket

**Request:**
```json
POST /api/projects/proj-123/tickets
{
  "title": "Fix the login bug",
  "description": "Users get a 500 error when using Safari.",
  "assignee_id": "user-456"
}
```

**Response (201):**
```json
{
  "message": "Ticket created",
  "ticket": {
    "id": "tick-789",
    "project_id": "proj-123",
    "title": "Fix the login bug",
    "status": "to_do",
    "reporter_id": "user-owner",
    "assignee_id": "user-456",
    "created_at": "2026-08-10T14:00:00Z"
  }
}
```

### 2. Move a Ticket (State Change)

**Request:**
```json
PUT /api/tickets/tick-789
{
  "status": "in_progress"
}
```

**Response (200):**
```json
{
  "message": "Ticket updated",
  "ticket": {
    "id": "tick-789",
    "status": "in_progress",
    "updated_at": "2026-08-11T09:30:00Z"
  }
}
```

### 3. Fetch a Project (The Heavy Read)

**Request:**
```http
GET /api/projects/proj-123 HTTP/1.1
```

**Response (200):**
```json
{
  "id": "proj-123",
  "name": "Website Redesign",
  "tickets": {
    "to_do": [
      { "id": "tick-100", "title": "Design Logo", "assignee": "Alice" }
    ],
    "in_progress": [
      { "id": "tick-789", "title": "Fix the login bug", "assignee": "Bob" }
    ],
    "review": [],
    "done": []
  }
}
```
*(Notice how the API groups the tickets by status. This makes it instantly ready for a frontend Kanban board to render the columns).*

---

## ⚠️ Error Responses

```json
// 403 Forbidden (Bob tries to delete a project owned by Alice)
{ "error": "Only the project owner can delete this project." }

// 404 Not Found (Trying to comment on a deleted ticket)
{ "error": "Ticket does not exist." }

// 400 Bad Request (Invalid state transition)
{ "error": "Status must be 'to_do', 'in_progress', 'review', or 'done'." }
```
