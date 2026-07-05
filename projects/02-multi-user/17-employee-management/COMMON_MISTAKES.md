# 🏢 Employee Management System (HRIS): Learn By Building

**"Build a multi-user API where Admins manage company departments, Managers oversee their assigned employees, and Employees can view the company directory."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Not Validating the Manager's Department

**Wrong:**
```javascript
app.put('/api/users/:id/title', async (req, res) => {
  // We check if they are a manager...
  if (req.user.role !== 'manager') return res.status(403).send("Forbidden");
  
  // But we let them update anyone!
  await db.query("UPDATE users SET job_title = ? WHERE id = ?", [req.body.title, req.params.id]);
});
```
*Why it's bad:* Manager Alice (Engineering) can just randomly change the job titles of people in the Sales department. 

**Right:**
Always include the Manager's `department_id` in the `WHERE` clause when updating an employee.
```javascript
  const result = await db.query(
    "UPDATE users SET job_title = ? WHERE id = ? AND department_id = ?", 
    [req.body.title, req.params.id, req.user.department_id]
  );
```

### ❌ Mistake 2: Hardcoding "My Team" Logic

**Wrong:**
```javascript
// Fetching all employees, then filtering in JS
const allUsers = await db.query("SELECT * FROM users");
const myTeam = allUsers.filter(u => u.department_id === req.user.department_id);
```
*Why it's bad:* When the company has 10,000 employees, you are pulling 10,000 records from the database into RAM just to find the 10 people on your team. This will crash your server.

**Right:**
Filter at the Database level using SQL. `SELECT * FROM users WHERE department_id = ?`.

### ❌ Mistake 3: SQL Injection via LIKE Search

**Wrong:**
```javascript
// Concatenating user input directly into a LIKE clause
const search = req.query.name;
const query = `SELECT * FROM users WHERE full_name LIKE '%${search}%'`;
```
*Why it's bad:* This is a classic SQL Injection vulnerability. If the user passes `' OR 1=1 --` as the search term, they can manipulate the query.

**Right:**
Use parameterized queries and add the wildcards in Javascript.
```javascript
const search = `%${req.query.name}%`;
const query = `SELECT * FROM users WHERE full_name LIKE ?`;
await db.query(query, [search]);
```

---
