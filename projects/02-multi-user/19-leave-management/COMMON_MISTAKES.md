# 🌴 Leave Management System: Learn By Building

**"Build a multi-user API where Employees request time off (PTO/Sick leave), and Managers approve or reject these requests while the system strictly enforces available leave balances."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Relying entirely on Node.js to prevent Overdrafts

**Wrong:**
```javascript
// Inside the approve route
const balance = await db.query("SELECT days_remaining FROM leave_balances WHERE user_id = ?", empId);

if (balance.days_remaining >= requestedDays) {
  await db.query("UPDATE leave_balances SET days_remaining = days_remaining - ?", requestedDays);
}
```
*Why it's bad:* If two managers (or a manager clicking twice very fast) trigger this code at the exact same millisecond, they both run the `SELECT` query. They both see `days = 5`. They both run the `UPDATE` query. The employee's balance is now mathematically negative, but your Javascript didn't catch it because of the asynchronous gap between SELECT and UPDATE.

**Right:**
Use a database-level `CHECK` constraint (`days_remaining >= 0`). Just blindly attempt the `UPDATE` in Javascript, and catch the database error if it drops below zero.

### ❌ Mistake 2: Bad Self-Referencing Queries

**Wrong:**
```javascript
// Fetching the inbox by downloading all requests and filtering in JS
const allRequests = await db.query("SELECT * FROM leave_requests WHERE status = 'pending'");
const allUsers = await db.query("SELECT * FROM users");

// Find users who report to me
const myTeamIds = allUsers.filter(u => u.manager_id === req.user.id).map(u => u.id);

// Filter requests
const myInbox = allRequests.filter(r => myTeamIds.includes(r.user_id));
```
*Why it's bad:* Massively inefficient. You are downloading the entire company's data into memory.

**Right:**
Use a SQL `JOIN` to do this directly in the database.
```sql
SELECT r.* 
FROM leave_requests r
JOIN users u ON r.user_id = u.id
WHERE r.status = 'pending' AND u.manager_id = ?
```

### ❌ Mistake 3: State Machine Flaws

**Wrong:**
Allowing an employee to `PUT /api/leave/request/:id` to change the dates *after* the manager has already approved it.

*Why it's bad:* The employee just took 20 days off when the manager only approved 2.

**Right:**
Once a request leaves the `pending` state, its core data (start date, end date, days) must become immutable (read-only).

---
