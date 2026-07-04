# To-Do List API: Learn By Building

**"Build the quintessential CRUD API with a twist: focus heavily on database relationships, pagination, and data validation."**

---


## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create Task
**POST `/api/tasks`**
- **Request**: `{ "title": "Buy Groceries", "priority": "high" }`
- **Response**: `201 Created`, `{ "id": 1, "title": "Buy Groceries", "status": "pending" }`

### Endpoint 2: Read Tasks (Paginated)
**GET `/api/tasks?page=2&limit=5&status=pending`**
- **Response**: `200 OK`
```json
{
  "data": [ { "id": 6, "title": "Task 6" }, ... ],
  "meta": { "current_page": 2, "total_pages": 10, "total_items": 50 }
}
```

### Endpoint 3: Update Task
**PATCH `/api/tasks/:id`**
- **Request**: `{ "status": "completed" }`
- **Response**: `200 OK`, `{ "id": 1, "status": "completed" }`

### Endpoint 4: Delete Task (Soft)
**DELETE `/api/tasks/:id`**
- **Response**: `204 No Content`

---
