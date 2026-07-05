# 📝 Complaint Management System: Learn By Building

**"Build a multi-user API for a city or large organization where Citizens submit complaints (like Potholes), and City Workers claim, update, and resolve those complaints via a strict state machine."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **State Machines** - Enforcing strict lifecycle rules for database rows (e.g., A complaint MUST go `open` -> `in_progress` -> `resolved` -> `closed`, without skipping steps or going backwards).  
✅ **Intent-Driven API Design** - Why generic `PUT /data` endpoints are dangerous, and why you should build specific action endpoints like `PUT /data/:id/claim`.  
✅ **Data Survivability** - Using `ON DELETE SET NULL` to retain important organizational data even when the user who created it leaves the system.

---

## 📋 Project Overview

### The Problem

In a collaborative environment (like a city fixing potholes, or a company's IT Helpdesk), data goes through a distinct lifecycle. 

If you allow users to randomly change the `status` column to whatever they want, chaos ensues. Workers might accidentally close tickets they never worked on. Citizens might reopen tickets from 5 years ago.

You must build a "State Machine." This means your code acts as a bouncer, constantly checking: "What state is this ticket in right now? Who is asking to change it? Is that transition mathematically allowed?"

**Your job:** Build an API that enforces a strict 4-step lifecycle for complaints, while retaining data integrity if users delete their accounts.

### Who Uses It

```
Citizen:
├─ POST /api/complaints (Creates an 'open' ticket)
└─ PUT /api/complaints/:id/close (Confirms the fix and 'closes' it)

Worker:
├─ PUT /api/complaints/:id/claim (Takes ownership, sets 'in_progress')
└─ PUT /api/complaints/:id/resolve (Marks their work as 'resolved')
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Safe Transition (The "Claim" Action)

Notice how the `UPDATE` statement includes the previous state in the `WHERE` clause. This is the secret to a perfect State Machine. It prevents Race Conditions (two workers claiming the same ticket at the exact same time).

```pseudocode
PUT /api/complaints/:id/claim:
  middlewares: [authenticateUser, requireRole(['worker'])]
  
  // 1. Atomic State Transition
  // We ONLY update it if it is currently 'open' and unassigned.
  result = db.query(`
    UPDATE complaints 
    SET status = 'in_progress', worker_id = ?
    WHERE id = ? AND status = 'open' AND worker_id IS NULL
  `, [req.user.id, req.params.id])
  
  // 2. Did the query actually change a row?
  if result.affectedRows === 0:
    return 409 "Conflict: Complaint is no longer open or already claimed."
    
  // 3. (Optional but good) Log the action
  db.query(`
    INSERT INTO comments (id, complaint_id, user_id, content)
    VALUES (UUID(), ?, ?, 'Ticket claimed and work started.')
  `, [req.params.id, req.user.id])
    
  return 200 "Complaint claimed successfully."
```

### 2. The Resolution Action (Worker validation)

A worker can only resolve a ticket if *they* are the one who claimed it.

```pseudocode
PUT /api/complaints/:id/resolve:
  middlewares: [authenticateUser, requireRole(['worker'])]
  
  // Note the WHERE clause checks for req.user.id
  result = db.query(`
    UPDATE complaints 
    SET status = 'resolved'
    WHERE id = ? AND status = 'in_progress' AND worker_id = ?
  `, [req.params.id, req.user.id])
  
  if result.affectedRows === 0:
    return 403 "Forbidden: You are not assigned to this complaint, or it is not in progress."
    
  return 200 "Complaint marked as resolved."
```

### 3. The Closure Action (Citizen validation)

Only the citizen who reported it can permanently close it (confirming they are happy with the fix).

```pseudocode
PUT /api/complaints/:id/close:
  middlewares: [authenticateUser, requireRole(['citizen'])]
  
  // Note the WHERE clause checks for req.user.id
  result = db.query(`
    UPDATE complaints 
    SET status = 'closed'
    WHERE id = ? AND status = 'resolved' AND citizen_id = ?
  `, [req.params.id, req.user.id])
  
  if result.affectedRows === 0:
    return 403 "Forbidden: Only the original reporter can close a resolved complaint."
    
  return 200 "Complaint permanently closed."
```

---

## ✅ Before Submission

- [ ] System separates Citizen and Worker roles.
- [ ] Foreign keys use `ON DELETE SET NULL` for users so civic data is never lost.
- [ ] API relies on Intent-Driven endpoints (`/claim`, `/resolve`, `/close`), NOT generic update endpoints.
- [ ] State Machine logic is enforced in the SQL `WHERE` clauses (e.g., `WHERE status = 'open'`).
- [ ] Workers can only resolve tickets they own; Citizens can only close tickets they own.
- [ ] Code is on GitHub.

**Success:** You have built a highly structured workflow application!
