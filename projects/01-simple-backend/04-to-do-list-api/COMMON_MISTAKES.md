# 📝 To-Do List API: Learn By Building

**"Build the classic To-Do list, but do it right: with user authentication, persistent database storage, and a clean RESTful API."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Trusting the Client for `user_id`

**Wrong:**
```javascript
// POST /api/tasks
// The frontend sends the user_id in the JSON body
const { title, user_id } = req.body;
db.insert("tasks", { title, user_id });
```
*Why it's bad:* A hacker can log in as themselves (User A), but send `{"title": "Hack", "user_id": "User_B_ID"}` in the JSON body. Now they are creating tasks in someone else's account!

**Right:**
NEVER trust the client. Always extract the user identity from the cryptographically signed JWT token on the server.
```javascript
// POST /api/tasks
const { title } = req.body;
const userId = req.user.id; // Extracted safely from the JWT in middleware
db.insert("tasks", { title, user_id: userId });
```

### ❌ Mistake 2: Missing Data Isolation in Queries (IDOR)

**Wrong:**
```javascript
// GET /api/tasks/:id
const task = await db.query("SELECT * FROM tasks WHERE id = ?", req.params.id);
```
*Why it's bad:* If User A requests `GET /api/tasks/user_b_task_id`, the database will happily return it. User A is now reading User B's private data!

**Right:**
```javascript
// ALWAYS scope by user_id
const task = await db.query("SELECT * FROM tasks WHERE id = ? AND user_id = ?", [req.params.id, req.user.id]);

if (!task) return res.status(404).json({ error: "Not found" });
```

### ❌ Mistake 3: SQL Injection Vulnerability

**Wrong:**
```javascript
// Using string concatenation
db.query(`SELECT * FROM tasks WHERE title = '${req.body.title}'`);
```
*Why it's bad:* If `req.body.title` is `' OR 1=1; --`, the query becomes `SELECT * FROM tasks WHERE title = '' OR 1=1; --'`, which returns every task in the database.

**Right:**
```javascript
// Using Parameterized Queries
db.query(`SELECT * FROM tasks WHERE title = ?`, [req.body.title]);
```

### ❌ Mistake 4: Using `PUT` when you mean `PATCH`

**Wrong:**
```javascript
// PUT /api/tasks/:id
// Client only sends { "is_completed": true }
db.query("UPDATE tasks SET is_completed = ?, title = ?, description = ? WHERE id = ?", 
  [req.body.is_completed, req.body.title, req.body.description, req.params.id]);
```
*Why it's bad:* A `PUT` request implies replacing the *entire* resource. If the client doesn't send the `title`, your update query might overwrite the existing title with `null`.

**Right:**
If you only want to update one field (like marking a task complete), use the `PATCH` HTTP method, and write a SQL query that only updates that specific column.
```javascript
// PATCH /api/tasks/:id/status
db.query("UPDATE tasks SET is_completed = ? WHERE id = ?", [req.body.is_completed, req.params.id]);
```

---
