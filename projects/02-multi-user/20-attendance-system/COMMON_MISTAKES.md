# 🕒 Employee Attendance System: Learn By Building

**"Build a multi-user API where Employees clock in and out daily, and Managers view attendance reports to track tardiness and total hours worked."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Trusting the Client's Clock

**Wrong:**
```javascript
// Trusting the frontend to tell you what time it is
app.post('/api/attendance/clock-in', async (req, res) => {
  const time = req.body.time; // { time: "08:50" }
  await db.query("INSERT INTO attendance_records (clock_in_time) VALUES (?)", time);
});
```
*Why it's bad:* An employee who wakes up at 9:30 AM can easily modify the JSON payload before sending it, claiming they clocked in at 8:50 AM to avoid being marked 'late'. 

**Right:**
NEVER trust the frontend for timestamps. The backend server must generate the time using `new Date()` or `CURRENT_TIMESTAMP` in SQL.

### ❌ Mistake 2: Storing the Total Hours as a fixed Column (Sometimes)

**Wrong:**
```sql
CREATE TABLE attendance_records (
  clock_in_time DATETIME,
  clock_out_time DATETIME,
  total_hours DECIMAL -- Manually calculated and inserted
);
```
*Why it's bad:* If a manager later edits the `clock_in_time` because the employee made a mistake, they might forget to update the `total_hours` column. Now your database contradicts itself.

**Right:**
Calculate the difference between `clock_out` and `clock_in` dynamically using SQL date functions (e.g., `TIMEDIFF()`) when generating the report. Only store derived data if performance is a critical issue (which for daily attendance, it rarely is).

### ❌ Mistake 3: The "Forever Open" Record

**Wrong:**
Assuming that every `clock_in` will eventually have a `clock_out`.
*Why it's bad:* Employees forget things. If your reporting logic assumes `clock_out - clock_in` always works, your code will crash when `clock_out` is `NULL`.

**Right:**
You must have a nightly sweeping script (Cron job) that finds all records where `clock_out IS NULL` and handles them (e.g., auto-closing them and flagging them for manager review).

---
