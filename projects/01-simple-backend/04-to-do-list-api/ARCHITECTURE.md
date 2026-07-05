# 📝 To-Do List API: Learn By Building

**"Build the classic To-Do list, but do it right: with user authentication, persistent database storage, and a clean RESTful API."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User signs up and creates an account.
2. User creates a task: "Buy groceries".
3. User creates a task: "Finish BCA assignment" with a due date of tomorrow.
4. User marks "Buy groceries" as completed.
5. User deletes "Buy groceries".
6. Another user logs in. They should NOT see the first user's tasks.

**What data do you need for each?**

After thinking, here's the data model:

```
Users
├─ id (UUID)
├─ username (unique)
├─ email (unique)
├─ password_hash
└─ created_at

Tasks
├─ id (UUID)
├─ user_id (links to Users - CRITICAL for privacy)
├─ title (The task itself)
├─ description (Optional details)
├─ is_completed (boolean)
├─ due_date (timestamp, optional)
└─ created_at
```

---

### Step 2: The Security Problem (Data Isolation)

**Question: How do you ensure User A cannot delete User B's task?**

**Bad Idea (Trusting the Client):**
```javascript
// DELETE /api/tasks/:id
const taskId = req.params.id;
db.query("DELETE FROM tasks WHERE id = ?", taskId);
```
*Why it's bad:* User A can just guess User B's task ID (e.g. `123`), send a DELETE request, and wipe out User B's data! This is a massive security flaw called Insecure Direct Object Reference (IDOR).

**Good Idea (Validating Ownership via JWT):**
```javascript
// DELETE /api/tasks/:id
// The JWT token tells us exactly who is making the request
const userId = req.user.id; 
const taskId = req.params.id;

// Delete ONLY IF the task belongs to this exact user
const result = db.query("DELETE FROM tasks WHERE id = ? AND user_id = ?", [taskId, userId]);

if (result.affectedRows === 0) {
  return res.status(404).json({ error: "Task not found or you don't own it" });
}
```

**Decision:** Every single route (GET, PUT, DELETE) must include `AND user_id = ?` in the SQL query to guarantee data isolation.

---

### Step 3: Database Architecture

```
┌──────────────────────────────────────────┐
│              Database                    │
├──────────────────────────────────────────┤
│                                          │
│  users ─────────┐                        │
│                 │                        │
│                 ├──► tasks               │
│                                          │
└──────────────────────────────────────────┘

Relationships:
- users.id → tasks.user_id (One-to-Many)
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Login / Register Screen              │  │
│  │ Task List View (Pending/Completed)   │  │
│  │ Add Task Form                        │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP Requests + JWT Header
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ Auth Middleware (Verifies JWT)       │  │
│  ├──────────────────────────────────────┤  │
│  │ API Routes                           │  │
│  │  - GET /tasks (Fetches only yours)   │  │
│  │  - POST /tasks                       │  │
│  │  - PUT /tasks/:id                    │  │
│  │  - DELETE /tasks/:id                 │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        SQL Queries (Always scoped by user_id)
              │
              ▼
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent storage                      │
└────────────────────────────────────────────┘
```
