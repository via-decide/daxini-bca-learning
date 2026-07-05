# 🎓 Student Information System: Learn By Building

**"Build a multi-user university backend where Admins manage courses, Professors assign grades, and Students view their academic transcripts."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Relying on the Frontend for Security Validation

**Wrong:**
```javascript
// PUT /api/enrollments/:id
app.put('/api/enrollments/:id', async (req, res) => {
  // Assuming the frontend only shows the grading button to the right professor
  await db.query("UPDATE enrollments SET grade = ? WHERE id = ?", [req.body.grade, req.params.id]);
});
```
*Why it's bad:* Hackers use tools like Postman to bypass your frontend completely. A malicious student who stole a professor's JWT could give themselves an A+ in every class at the university.

**Right:**
The server must always independently verify that the logged-in professor *actually teaches* the course they are trying to grade.

### ❌ Mistake 2: Missing the Junction Table

**Wrong:**
```sql
CREATE TABLE courses (
  id TEXT PRIMARY KEY,
  student_1_id TEXT,
  student_2_id TEXT,
  -- What happens if there are 300 students in a class?
);
```
*Why it's bad:* Hardcoding columns for relationships limits how much data you can store.

**Right:**
Use a Many-to-Many Junction Table (`enrollments`). This allows a single course to have millions of students, and a single student to take millions of courses, without ever changing the database schema.

### ❌ Mistake 3: Storing Calculated Values Permanently

**Wrong:**
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  gpa DECIMAL(3,2) -- Updating this every single time a grade changes
);
```
*Why it's bad:* Storing a calculation means it can get out of sync. If an admin deletes a course from 3 years ago, they now have to remember to recalculate the GPA of every student who took it.

**Right:**
Calculate the GPA on the fly using SQL `SUM()` whenever the transcript is requested. (Note: For massive, slow databases, caching this value is a valid advanced technique, but it is an anti-pattern for basic relational design).

---
