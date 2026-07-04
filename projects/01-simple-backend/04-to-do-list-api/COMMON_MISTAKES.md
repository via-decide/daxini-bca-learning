# To-Do List API: Learn By Building

**"Build the quintessential CRUD API with a twist: focus heavily on database relationships, pagination, and data validation."**

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
