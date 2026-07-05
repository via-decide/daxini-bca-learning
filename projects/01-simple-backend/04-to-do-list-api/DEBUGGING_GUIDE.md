# 📝 To-Do List API: Learn By Building

**"Build the classic To-Do list, but do it right: with user authentication, persistent database storage, and a clean RESTful API."**

---

## 🧪 Testing Scenarios

### Scenario 1: Creating a Task

```
1. Login and get your JWT token.
2. POST to /api/tasks with `{"title": "Test Task"}`
3. Expected: Returns 201 Created.
4. Verify: Look at the database. The `user_id` column for the new task MUST match your user's ID. If it is null, your auth middleware is broken.
```

### Scenario 2: Data Isolation (The IDOR Test)

```
1. Create User A. Create Task X. Note the task ID (e.g., `task-123`).
2. Create User B. Login as User B and get their JWT token.
3. As User B, send `GET /api/tasks/task-123`.
4. Expected: Returns 404 Not Found (or 403 Forbidden).
5. As User B, send `DELETE /api/tasks/task-123`.
6. Expected: Returns 404 Not Found. 
7. Verify: Log back in as User A. Task X should still exist!
```

### Scenario 3: SQL Injection Check

```
1. Login.
2. POST to /api/tasks with `{"title": "Task'); DROP TABLE tasks; --"}`
3. Expected: Task is created successfully with that literal weird title.
4. Verify: The `tasks` table still exists. If you used string concatenation instead of parameterized queries, your table is gone!
```

### Scenario 4: Validating Required Fields

```
1. Login.
2. POST to /api/tasks with `{}` (empty body)
3. Expected: 400 Bad Request ("Title is required").
4. Verify: DB should not have a task with a null title.
```

---
