# Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage seating capacity, and attendees can register and receive tickets."**

---


## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: How do we track capacity?**
- Approach A: Have a field `capacity_remaining` on the Event and subtract 1 every time someone registers.
- Approach B: Calculate it dynamically: `capacity - (SELECT COUNT(*) FROM Registrations WHERE event_id = X)`.

**Why Approach A is dangerous:** If the `-1` logic fails or goes out of sync with the actual number of rows in the Registrations table, your data is corrupted.
**Solution (Approach B):** It is safer to rely on the actual count of registration rows, using a database transaction to lock the count check and the insert together.

### Step 2: Database Architecture

```text
Users
├─ id (UUID)
├─ email
└─ role (ENUM: 'organizer', 'attendee')

Events
├─ id (UUID)
├─ organizer_id (FK -> Users)
├─ title (VARCHAR)
├─ date (TIMESTAMP)
└─ capacity (INT)

Registrations (Tickets)
├─ id (UUID) // This acts as the Ticket ID
├─ event_id (FK -> Events)
├─ attendee_id (FK -> Users)
├─ status (ENUM: 'registered', 'checked_in', 'cancelled')
└─ registered_at (TIMESTAMP)
```

---
