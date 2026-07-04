# Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage seating capacity, and attendees can register and receive tickets."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Organizer Overreach (IDOR)
**What's wrong:** Organizer A runs `/api/events/Event_B/attendees` and downloads the attendee list for Organizer B's event.
**Why it's bad:** Massive data privacy breach.
**How to fix:** Whenever an Organizer requests data for an event, verify they own it: `SELECT * FROM Events WHERE id = req.event_id AND organizer_id = req.user.id`.

### ❌ Mistake 2: Soft Deletes vs Capacity
**What's wrong:** An attendee cancels their ticket. You set `status = 'cancelled'`. But your capacity check does `SELECT count(*) FROM Registrations`. The sold-out event stays sold-out forever!
**How to fix:** Ensure your `COUNT()` queries explicitly filter out cancelled tickets.

---
