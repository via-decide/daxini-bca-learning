# To-Do List API: Learn By Building

**"Build the quintessential CRUD API with a twist: focus heavily on database relationships, pagination, and data validation."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **CRUD Operations** - Creating, Reading, Updating, and Deleting data cleanly via REST
✅ **Data Validation** - Using schemas to ensure clients can't submit empty or malformed tasks
✅ **Pagination** - Returning data in chunks (e.g., 10 items per page) so the API scales
✅ **Soft Deletes** - Learning why we rarely actually `DELETE` data from a production database
✅ **HTTP Status Codes** - When to use 200, 201, 400, 404, and 500 correctly

---

## 📋 Project Overview

### The Problem
While a To-Do list sounds simple, it's the perfect isolated environment to learn how data moves between a client, a server, and a database. If you build a bad To-Do list, it crashes when someone submits 10,000 tasks. A good To-Do list handles pagination, validates inputs, and uses proper database practices like Soft Deletes.

### Who Uses It
```
Frontend App / Mobile App:
├─ Fetches tasks for the current view (Page 1)
├─ Sends a POST request to add a new task
└─ Sends a PATCH request when a user checks a box

Backend System (You):
├─ Receives the request
├─ Validates the data (Is the title empty?)
└─ Updates the database safely
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Mobile App  │ ──> │ Backend API  │ ──> │  PostgreSQL  │
│  (Frontend)  │ <── │ (Controller) │ <── │  (Database)  │
└──────────────┘     └──────┬───────┘     └──────────────┘
                            │
                     ┌──────┴───────┐
                     │ Input Schema │
                     │  Validation  │
                     └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: What information must the system store?**
- Obviously, the task name and whether it's completed.
- Do we need due dates? Yes.
- Do we need priorities? Yes (High, Medium, Low).
- Should a deleted task actually be wiped from the hard drive? No, we use a `deleted_at` timestamp.

**After thinking, here's the data model:**
- A single `tasks` table with a robust set of columns. 

### Step 2: Architecture Diagram

```text
1. Client POSTs /tasks
2. API validates the JSON body (e.g., title must be > 3 chars).
3. If invalid -> Return 400 Bad Request
4. If valid -> Insert into DB
5. DB returns new row ID
6. API returns 201 Created with the new Task JSON
```

### Step 3: Data Flow (Pagination)
1. User has 500 tasks.
2. App requests `GET /tasks?page=1&limit=10`.
3. Backend calculates `OFFSET 0 LIMIT 10`.
4. Backend returns 10 tasks + metadata (`total_pages: 50`).

---

## 🗄️ Database: Design, Don't Code

### Schema Design (Think Before SQL)

```sql
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  priority VARCHAR(20) DEFAULT 'medium',
  status VARCHAR(20) DEFAULT 'pending', -- pending, in_progress, completed
  due_date DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME NULL -- Soft delete column
);
```

### Design Questions

1. **What is a "Soft Delete"?**
   Instead of running `DELETE FROM tasks WHERE id = 5`, you run `UPDATE tasks SET deleted_at = NOW() WHERE id = 5`. Then, all your `SELECT` queries change to `WHERE deleted_at IS NULL`. This allows you to recover accidentally deleted data, which is standard enterprise practice.

2. **Why use a `status` string instead of a boolean `is_completed`?**
   Boolean is fine for simple apps. But real apps usually evolve. "Done" and "Not Done" quickly becomes "Not Started", "In Progress", "Blocked", and "Done". Using a string/enum prepares you for the future.

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

## 🧠 Implementation: Pseudocode First

```text
FUNCTION get_tasks(request):
    // 1. Extract Query Parameters with Defaults
    page = request.query.page OR 1
    limit = request.query.limit OR 10
    filter_status = request.query.status OR NULL
    
    // 2. Calculate Math for Pagination
    offset = (page - 1) * limit
    
    // 3. Build Query
    base_query = "SELECT * FROM tasks WHERE deleted_at IS NULL"
    
    IF filter_status IS NOT NULL:
        base_query += " AND status = :filter_status"
        
    // 4. Execute Query with Pagination
    final_query = base_query + " ORDER BY created_at DESC LIMIT :limit OFFSET :offset"
    results = Database.execute(final_query)
    
    // 5. Get Total Count for Metadata
    count_query = "SELECT COUNT(*) FROM tasks WHERE deleted_at IS NULL"
    total_items = Database.execute(count_query)
    total_pages = ceil(total_items / limit)
    
    // 6. Return standard paginated format
    RETURN {
        data: results,
        meta: {
            page: page,
            limit: limit,
            total_items: total_items,
            total_pages: total_pages
        }
    }
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Returning ALL data at once
**What's wrong:** Writing `SELECT * FROM tasks` without limits.
**Why it's bad:** It works fine with 5 tasks. When the user has 5,000 tasks, the database locks up, the server runs out of memory transferring the JSON, and the mobile app crashes trying to render it.
**How to fix:** Always, always implement pagination (`LIMIT` and `OFFSET`) on any API endpoint that returns a list.

### ❌ Mistake 2: Trusting Client Input
**What's wrong:** Inserting `req.body.title` directly into the database.
**Why it's bad:** What if the client sends an empty string? Or an object? Or SQL injection?
**How to fix:** Use an input validation library (like Zod, Joi, or Pydantic) to verify that `title` is a string, exists, and is less than 255 characters *before* it touches your database logic.

---

## 🧪 Testing: How to Verify

### Test 1: The 404 Check
- Send `GET /api/tasks/99999` (an ID that doesn't exist).
- Ensure the API returns a proper `404 Not Found` status code, not a `500 Internal Server Error`.

### Test 2: Validation Failure
- Send `POST /api/tasks` with `{ "title": "" }`.
- Ensure it returns `400 Bad Request` with an error message saying "Title is required".

---

## 🛠️ Debugging: When Things Break

### Problem: Page 2 returns the exact same data as Page 1
**Root Cause:** Your math for the `OFFSET` calculation is wrong, or you aren't actually passing the offset value into your SQL query.
**Solution:** Print the generated SQL query to the console before executing it. Verify that it says `OFFSET 10` for page 2 (assuming a limit of 10).

---

## 📚 Resources

- **REST Guidelines**: Microsoft REST API Guidelines
- **HTTP Status Codes**: HTTP Status Dogs (Visual guide)
- **Pagination**: Offset vs Cursor Pagination explained

---

## ✅ Before Submission

- [ ] Does `DELETE` actually delete the row, or does it update `deleted_at`?
- [ ] Are you returning the correct HTTP status codes?
- [ ] Is input validation strictly enforced?
- [ ] Does pagination metadata accurately reflect the total number of items?

---

**Build this and learn: The foundational mechanics of every web backend in existence.**
