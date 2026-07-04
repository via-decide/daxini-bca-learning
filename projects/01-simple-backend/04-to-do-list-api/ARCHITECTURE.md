# To-Do List API: Learn By Building

**"Build the quintessential CRUD API with a twist: focus heavily on database relationships, pagination, and data validation."**

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
