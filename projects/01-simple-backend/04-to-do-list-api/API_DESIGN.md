# 📝 To-Do List API: API Design

**"Build the classic To-Do list, but do it right: with user authentication, persistent database storage, and a clean RESTful API."**

---

## 🔗 API Endpoints

### Authentication (Public)

```
POST   /api/auth/register     → Create a new user account
POST   /api/auth/login        → Authenticate and return a JWT
```

### Task Management (Requires JWT Authentication)

*Note: All these endpoints extract `user_id` from the JWT token. The client never explicitly sends `user_id` in the body.*

```
GET    /api/tasks             → List all tasks for the logged-in user
POST   /api/tasks             → Create a new task
GET    /api/tasks/:id         → Get details for a specific task
PUT    /api/tasks/:id         → Fully update a task (title, description, due date)
PATCH  /api/tasks/:id/status  → Toggle the completed status (true/false)
DELETE /api/tasks/:id         → Delete a task
```

---

## 📦 Request/Response Examples

### 1. Create a Task

**Request:**
```json
POST /api/tasks
Authorization: Bearer <jwt_token>
{
  "title": "Buy groceries",
  "description": "Milk, eggs, and bread",
  "due_date": "2026-10-05T12:00:00Z"
}
```

**Response (201):**
```json
{
  "message": "Task created successfully",
  "task": {
    "id": "uuid-task-1",
    "title": "Buy groceries",
    "description": "Milk, eggs, and bread",
    "is_completed": false,
    "due_date": "2026-10-05T12:00:00Z",
    "created_at": "2026-10-01T08:00:00Z"
  }
}
```

### 2. Update Task Status (Mark Complete)

**Request:**
```json
PATCH /api/tasks/uuid-task-1/status
Authorization: Bearer <jwt_token>
{
  "is_completed": true
}
```

**Response (200):**
```json
{
  "message": "Task status updated",
  "task": {
    "id": "uuid-task-1",
    "title": "Buy groceries",
    "is_completed": true
  }
}
```

### 3. Fetch Tasks (With Filtering)

**Request:**
```http
GET /api/tasks?status=pending&sort=due_date HTTP/1.1
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "tasks": [
    {
      "id": "uuid-task-2",
      "title": "Finish BCA Assignment",
      "is_completed": false,
      "due_date": "2026-10-02T23:59:00Z"
    },
    {
      "id": "uuid-task-3",
      "title": "Call Mom",
      "is_completed": false,
      "due_date": null
    }
  ],
  "meta": {
    "total": 2,
    "filter": "pending"
  }
}
```

---

## ⚠️ Error Responses

```json
// 401 Unauthorized (Missing or invalid JWT token)
{ "error": "Authentication required. Please log in." }

// 404 Not Found (Task ID doesn't exist, OR it belongs to a different user)
{ "error": "Task not found" }

// 400 Bad Request
{ "error": "Title is required and must be between 1 and 100 characters." }
```
