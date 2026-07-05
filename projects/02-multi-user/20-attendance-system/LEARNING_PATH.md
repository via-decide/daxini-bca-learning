# 🕒 Employee Attendance System: Learn By Building

**"Build a multi-user API where Employees clock in and out daily, and Managers view attendance reports to track tardiness and total hours worked."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Server-Side Authority** - Why APIs must never trust client-provided timestamps, and how to use server-generated Time/Dates securely.  
✅ **Compound Unique Constraints** - Using `UNIQUE(column1, column2)` to strictly enforce business rules (e.g., One record, per user, per day).  
✅ **Nightly Cron Sweepers** - Building background tasks to clean up incomplete data (missing clock-outs) before the next business day begins.

---

## 📋 Project Overview

### The Problem

Attendance systems are prone to cheating and human error. If you let the mobile app send the timestamp, employees can spoof it. If you don't restrict the number of clock-ins, angry button-mashers will create 15 records for the same day. If you assume everyone clocks out, your math will break when someone forgets.

**Your job:** Build an API that acts as the absolute authority on Time. It must strictly enforce a one-record-per-day rule using Database Constraints, automatically calculate tardiness upon creation, and provide clean reports to managers.

### Who Uses It

```
Employee:
├─ POST /api/attendance/clock-in (Starts the day)
└─ PUT /api/attendance/clock-out (Ends the day)

Manager:
└─ GET /api/reports/daily (Views the team's attendance status)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Clock-In Action (Server Authority)

Notice how the `request.body` is completely empty. We don't ask the user for *anything*.

```pseudocode
POST /api/attendance/clock-in:
  middlewares: [authenticateUser, requireRole(['employee'])]
  
  // 1. Get the current exact time from the SERVER
  now = new Date()
  today_date = extractDate(now) // e.g. "2026-10-15"
  current_time = extractTime(now) // e.g. "09:15:00"
  
  // 2. Fetch the user's expected start time to check tardiness
  user = db.query("SELECT expected_start_time FROM users WHERE id = ?", req.user.id)
  
  status = 'present'
  if (current_time > user.expected_start_time) {
    status = 'late'
  }
  
  // 3. Attempt Insert (Relies on UNIQUE constraint to prevent double clock-in)
  try:
    db.query(`
      INSERT INTO attendance_records (id, user_id, date, clock_in_time, status)
      VALUES (UUID(), ?, ?, ?, ?)
    `, [req.user.id, today_date, now, status])
    
    return 201 "Clocked In!"
    
  catch (error):
    if isUniqueViolation(error):
      return 409 "You have already clocked in today."
```

### 2. The Clock-Out Action

```pseudocode
PUT /api/attendance/clock-out:
  middlewares: [authenticateUser, requireRole(['employee'])]
  
  now = new Date()
  today_date = extractDate(now)
  
  // 1. We ONLY update a record if it belongs to the user, is for TODAY, 
  // and hasn't been clocked out yet.
  result = db.query(`
    UPDATE attendance_records 
    SET clock_out_time = ?
    WHERE user_id = ? AND date = ? AND clock_out_time IS NULL
  `, [now, req.user.id, today_date])
  
  if result.affectedRows === 0:
    return 400 "No active clock-in found for today, or already clocked out."
    
  return 200 "Clocked Out!"
```

### 3. The Manager's Daily Report

The manager needs to see a list of all their employees and their current status. 

```pseudocode
GET /api/reports/daily:
  middlewares: [authenticateUser, requireRole(['manager'])]
  
  target_date = request.query.date || today()
  
  // We use a LEFT JOIN from Users to Attendance so that we can see 
  // employees who are 'absent' (they have NO attendance record for today).
  report = db.query(`
    SELECT 
      u.full_name,
      COALESCE(a.status, 'absent') as status,
      a.clock_in_time,
      a.clock_out_time
    FROM users u
    LEFT JOIN attendance_records a 
      ON u.id = a.user_id AND a.date = ?
    WHERE u.manager_id = ?
    ORDER BY u.full_name ASC
  `, [target_date, req.user.id])
  
  return 200 { date: target_date, attendance: report }
```

---

## ✅ Before Submission

- [ ] API does not accept timestamps from the frontend payload; it uses server time.
- [ ] Database enforces a `UNIQUE(user_id, date)` constraint to prevent multiple records per day.
- [ ] Tardiness (`status = 'late'`) is calculated automatically by the backend upon clock-in.
- [ ] The Manager Report uses a `LEFT JOIN` to display employees who haven't clocked in at all as 'absent'.
- [ ] Code is on GitHub.

**Success:** You have built a secure and authoritative time-tracking system!
