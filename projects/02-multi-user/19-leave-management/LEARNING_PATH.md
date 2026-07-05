# 🌴 Leave Management System: Learn By Building

**"Build a multi-user API where Employees request time off (PTO/Sick leave), and Managers approve or reject these requests while the system strictly enforces available leave balances."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Self-Referencing Relationships** - Building organizational hierarchies where a table row points to another row in the *same* table (Employee -> Manager).  
✅ **Race Condition Prevention** - Using SQL `CHECK` constraints to prevent mathematical overdrafts during simultaneous API requests.  
✅ **Transactional Workflows** - Combining State Machine transitions (Pending -> Approved) with Financial operations (Balance Deduction) safely.

---

## 📋 Project Overview

### The Problem

Leave Management combines an Organizational Hierarchy with a Bank Account. 

The Hierarchy problem: How do you know who should approve a request? You must link an employee to their specific manager in the database, and write queries that join those tables together so the manager only sees their own team's requests.

The Bank Account problem: Paid Time Off (PTO) is exactly like money. If an employee has 5 days, they cannot spend 6. If they try to spend 4 days twice at the exact same time, the backend cannot allow their balance to drop below zero.

**Your job:** Build an API that uses SQL JOINs to populate manager inboxes, and Database Transactions combined with `CHECK` constraints to safely deduct leave balances.

### Who Uses It

```
Employee:
├─ POST /api/leave/request (Asks for time off)
└─ GET /api/leave/balances (Checks how many days they have left)

Manager:
├─ GET /api/leave/inbox (Sees who is asking for time off)
└─ PUT /api/leave/requests/:id/approve (Authorizes the leave and deducts the balance)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Generating the Manager Inbox (The Self-Referencing JOIN)

We want to find all pending requests, but only for users whose `manager_id` is the person currently logged in.

```pseudocode
GET /api/leave/inbox:
  middlewares: [authenticateUser, requireRole(['manager'])]
  
  // We join the requests table to the users table
  // so we can filter by the user's manager_id.
  inbox = db.query(`
    SELECT 
      r.id as request_id,
      u.full_name as employee_name,
      r.leave_type,
      r.start_date,
      r.end_date,
      r.requested_days
    FROM leave_requests r
    JOIN users u ON r.user_id = u.id
    WHERE r.status = 'pending' AND u.manager_id = ?
    ORDER BY r.created_at ASC
  `, req.user.id)
  
  return 200 { pending_requests: inbox }
```

### 2. The Approval Transaction

This is the most critical part of the app. It must be a transaction.

```pseudocode
PUT /api/leave/requests/:id/approve:
  middlewares: [authenticateUser, requireRole(['manager'])]
  
  req_id = request.params.id
  
  // 1. Verify Ownership & State
  request_info = db.query(`
    SELECT r.user_id, r.leave_type, r.requested_days 
    FROM leave_requests r
    JOIN users u ON r.user_id = u.id
    WHERE r.id = ? AND r.status = 'pending' AND u.manager_id = ?
  `, [req_id, req.user.id])
  
  if !request_info: return 403 "Forbidden or already processed"
  
  // 2. Start Transaction
  db.execute("BEGIN TRANSACTION")
  
  try:
    // 3. Mark as Approved
    db.query(`
      UPDATE leave_requests 
      SET status = 'approved', manager_comment = ? 
      WHERE id = ?
    `, [request.body.comment, req_id])
    
    // 4. Deduct the Balance
    // If this drops days_remaining below 0, the DB throws a CHECK constraint error!
    db.query(`
      UPDATE leave_balances 
      SET days_remaining = days_remaining - ? 
      WHERE user_id = ? AND leave_type = ?
    `, [request_info.requested_days, request_info.user_id, request_info.leave_type])
    
    // 5. Commit
    db.execute("COMMIT")
    return 200 "Approved and deducted."
    
  catch (error):
    // This catches the CHECK constraint violation!
    db.execute("ROLLBACK")
    return 400 "Insufficient balance to approve this request."
```

### 3. Application Validation (Employee)

When the employee first applies, do a quick sanity check so you don't bother the manager with an impossible request.

```pseudocode
POST /api/leave/request:
  middlewares: [authenticateUser]
  
  // Quick check
  balance = db.query(`
    SELECT days_remaining FROM leave_balances 
    WHERE user_id = ? AND leave_type = ?
  `, [req.user.id, req.body.leave_type])
  
  if balance.days_remaining < req.body.requested_days:
    return 400 "You don't have enough days left to request this."
    
  // ... proceed to insert the pending request ...
```

---

## ✅ Before Submission

- [ ] System supports self-referencing hierarchy (Employees report to a Manager ID).
- [ ] Manager Inbox uses a `JOIN` to fetch only requests belonging to their team.
- [ ] The Approval endpoint uses a Database Transaction.
- [ ] The `leave_balances` table uses a `CHECK (days_remaining >= 0)` constraint to prevent mathematical overdrafts via race conditions.
- [ ] Code is on GitHub.

**Success:** You have built a transactional hierarchy workflow!
