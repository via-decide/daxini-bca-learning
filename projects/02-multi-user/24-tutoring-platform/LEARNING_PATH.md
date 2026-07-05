# 📚 Tutoring Platform API: Learn By Building

**"Build a multi-user API where Tutors define their availability slots, and Students book sessions using those slots without causing double-bookings."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **UTC Time Standardization** - The golden rule of date/time handling: Store in UTC, transmit in UTC, display in Local Time.  
✅ **Booking Race Conditions** - Using atomic SQL updates or Unique Partial Indexes to ensure a finite resource (a 1-hour slot) is never sold to two people.  
✅ **Temporal Overlap Logic** - Writing SQL queries to check if two time ranges intersect before allowing an insert.

---

## 📋 Project Overview

### The Problem

Building a booking system introduces two massive headaches: Timezones and Concurrency.

If you don't standardize timezones, a student in London will book a tutor in New York, and they will both show up at completely different times.

If you don't handle concurrency, two students clicking "Book" on a popular tutor's final slot will both get a success message, but only one tutor will show up.

**Your job:** Build an API that enforces UTC standards, checks for overlapping schedules when tutors create slots, and uses atomic database transactions to guarantee perfect 1-to-1 bookings.

### Who Uses It

```
Tutor:
├─ POST /api/slots (Creates an open block of time)
└─ GET /api/bookings/my-schedule (Sees who booked them)

Student:
├─ GET /api/tutors/:id/slots (Finds a time that works)
└─ POST /api/slots/:id/book (Claims the time)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Preventing Slot Overlaps (Tutor creating a slot)

When a tutor creates a slot from 10:00 to 11:00, we must ensure they don't already have a slot that overlaps (e.g., 10:30 to 11:30).

*Logic: Two date ranges (StartA to EndA) and (StartB to EndB) overlap IF: (StartA < EndB) AND (EndA > StartB).*

```pseudocode
POST /api/slots:
  middlewares: [authenticateUser, requireRole(['tutor'])]
  
  new_start = request.body.start_time
  new_end = request.body.end_time
  
  // Check for overlaps in the database
  overlaps = db.query(`
    SELECT id FROM availability_slots 
    WHERE tutor_id = ? 
      AND start_time < ? 
      AND end_time > ?
  `, [req.user.id, new_end, new_start])
  
  if overlaps.length > 0:
    return 400 "This slot overlaps with an existing slot in your schedule."
    
  // Insert
  db.query(`
    INSERT INTO availability_slots (id, tutor_id, start_time, end_time)
    VALUES (UUID(), ?, ?, ?)
  `, [req.user.id, new_start, new_end])
  
  return 201 "Slot created."
```

### 2. The Atomic Booking Transaction

This prevents double-booking. We use the `UPDATE` query on the `availability_slots` table as our concurrency lock.

```pseudocode
POST /api/slots/:id/book:
  middlewares: [authenticateUser, requireRole(['student'])]
  
  target_slot_id = request.params.id
  
  db.execute("BEGIN TRANSACTION")
  
  try:
    // 1. ATTEMPT TO LOCK AND CLAIM THE SLOT
    // We only update it IF it is currently false.
    result = db.query(`
      UPDATE availability_slots 
      SET is_booked = true 
      WHERE id = ? AND is_booked = false
    `, target_slot_id)
    
    // If affectedRows is 0, it means it was already booked (or doesn't exist).
    if result.affectedRows === 0:
      throw new Error("Slot is no longer available.")
      
    // 2. Create the Booking Record
    db.query(`
      INSERT INTO bookings (id, slot_id, student_id)
      VALUES (UUID(), ?, ?)
    `, [target_slot_id, req.user.id])
    
    db.execute("COMMIT")
    return 201 "Booked successfully!"
    
  catch (error):
    db.execute("ROLLBACK")
    return 409 error.message
```

---

## ✅ Before Submission

- [ ] System handles `tutor` and `student` roles securely.
- [ ] Backend stores and processes all timestamps in UTC.
- [ ] Tutors cannot create overlapping availability slots.
- [ ] The Booking endpoint uses an atomic SQL `UPDATE` or a Unique Constraint to prevent race conditions (double bookings).
- [ ] Code is on GitHub.

**Success:** You have built a robust temporal scheduling engine!
