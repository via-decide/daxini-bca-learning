# 🎓 College Management System API: Learn By Building

**"Build a multi-user API where Admins manage course catalogs, Professors grade students, and Students enroll in courses up to a maximum credit limit."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Calculating GPA on the Frontend

**Wrong:**
The backend sends a list of courses and grades, and the React frontend loops through them to calculate the GPA.

*Why it's bad:* If the student uses a mobile app, a web app, and an integration, you have to rewrite the GPA logic three times. The backend is the absolute authority on academic math.

**Right:**
Calculate the GPA using a SQL Aggregation Query (e.g., `SUM(credits * grade_weight) / SUM(credits)`) or calculate it in the Node.js backend before sending the JSON response.

### ❌ Mistake 2: Missing the Transaction during Enrollment

**Wrong:**
```javascript
// Step 1: Check capacity
const count = await db.query("SELECT COUNT(*) FROM enrollments WHERE course_id = ?");
const course = await db.query("SELECT capacity FROM courses WHERE id = ?");

if (count < course.capacity) {
  // RACE CONDITION! Someone else might enroll right here!
  await db.query("INSERT INTO enrollments...");
}
```

**Right:**
Wrap it in a Transaction. Better yet, let the database handle it using an atomic conditional INSERT.
```sql
INSERT INTO enrollments (id, student_id, course_id)
SELECT UUID(), ?, ? 
FROM courses 
WHERE id = ? AND capacity > (SELECT COUNT(*) FROM enrollments WHERE course_id = ?)
```

### ❌ Mistake 3: Shallow Grading Validation

**Wrong:**
Checking if the user is a `professor`, but failing to check if they teach the specific course they are assigning grades for. 

*Why it's bad:* An angry professor can log in and fail every student in the college.

**Right:**
Always `JOIN` the `enrollments` table to the `courses` table in your `UPDATE` statement to enforce ownership.

---
