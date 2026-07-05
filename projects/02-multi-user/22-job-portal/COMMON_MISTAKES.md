# 💼 Job Portal API: Learn By Building

**"Build a multi-user API where Employers post job listings, Candidates submit applications (with resumes), and Employers track the application status through a hiring pipeline."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Shallow Ownership Checks

**Wrong:**
```javascript
// A route to let an employer update an application's status
app.put('/api/applications/:id/status', async (req, res) => {
  // We check if they are an employer...
  if (req.user.role !== 'employer') return res.status(403).send("Forbidden");
  
  // But we let them update ANY application ID they guess!
  await db.query("UPDATE applications SET status = ? WHERE id = ?", [req.body.status, req.params.id]);
});
```
*Why it's bad:* Employer Bob can change the status of Employer Elon's candidates, sabotaging Elon's hiring process.

**Right:**
Use a SQL `JOIN` to verify that the application belongs to a job, which belongs to a company, which belongs to the logged-in employer.
```sql
UPDATE applications 
SET status = ? 
WHERE id = ? 
  AND job_id IN (
    SELECT j.id FROM job_postings j
    JOIN companies c ON j.company_id = c.id
    WHERE c.employer_id = ?
  )
```

### ❌ Mistake 2: Leaking Data to Candidates

**Wrong:**
When a Candidate fetches `GET /api/applications/me`, the backend does a `SELECT *` and joins the employer's details, returning the employer's `password_hash` or private company notes.

**Right:**
Always explicitly list the columns you want to return.
`SELECT a.id, a.status, j.title, c.name as company_name FROM applications a ...`

### ❌ Mistake 3: Client-Side Spam Control

**Wrong:**
Disabling the "Apply" button in React after it's clicked, but not enforcing a Unique Constraint in the Database.

*Why it's bad:* Anyone can open Chrome DevTools, re-enable the button, or use Postman to send 10,000 requests and crash your database. The Database is the ONLY source of truth.

---
