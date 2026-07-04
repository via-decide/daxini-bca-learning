# Hospital Management System: Learn By Building

**"Build a multi-user system for managing patient records, doctor appointments, and hospital administration with strict access controls."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Missing Horizontal Authorization (IDOR)
**What's wrong:** A patient logs in, their ID is 5. They call `GET /api/patients/6/records` and the API returns Patient 6's medical data.
**Why it's bad:** This is an Insecure Direct Object Reference (IDOR). You checked if they were logged in, but you didn't check if they *owned* the data they requested.
**How to fix:** Always validate `requested_id == logged_in_user.id` or `logged_in_user.role == 'admin'`.

### ❌ Mistake 2: Overlapping Appointments
**What's wrong:** Two patients book the exact same doctor at 10:00 AM.
**Why it's bad:** The doctor cannot be in two places at once.
**How to fix:** Before inserting an appointment, query the DB: `SELECT count(*) FROM Appointments WHERE doctor_id = X AND time = Y`. If count > 0, return `409 Conflict`.

---
