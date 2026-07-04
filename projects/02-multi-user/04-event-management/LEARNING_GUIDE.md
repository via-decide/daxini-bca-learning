# Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage seating capacity, and attendees can register and receive tickets."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Capacity Enforcement** - Safely decrementing available ticket counts without overselling.
✅ **Ticket Generation** - Generating unique identifiers (QR codes/Hashes) to verify attendance.
✅ **One-to-Many Relationships** - An Organizer has many Events. An Event has many Attendees.
✅ **Email Notifications (Mocked)** - Triggering secondary actions (like sending a ticket) after a successful database insert.

---

## 📋 Project Overview

### The Problem
When you host a conference with 100 seats, you need a system to ensure exactly 100 people can register. If 101 people register, someone will be forced to stand. Furthermore, users need a way to prove they registered when they show up at the door, which requires a uniquely verifiable ticket.

### Who Uses It
```
Organizer (Admin):
├─ Creates "Tech Meetup 2025" (Capacity: 100, Price: Free).
└─ Views list of registered attendees and checks them in at the door.

Attendee (User):
├─ Browses upcoming events.
├─ Registers for an event.
└─ Receives a unique Ticket ID to show at the door.
```

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

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Register for Event
**POST `/api/events/:id/register`**
- **Auth**: Requires Attendee JWT.
- **Response (Success)**: `201 Created` with Ticket ID.
- **Response (Full)**: `409 Conflict` "Event is sold out".

### Endpoint 2: Check-In Attendee
**POST `/api/tickets/:ticket_id/checkin`**
- **Auth**: Requires Organizer JWT (must be the organizer who owns the event).
- **Response**: `200 OK` "Successfully checked in".

---

## 🧠 Implementation: Pseudocode First

### 1. The Safe Registration Logic
```text
FUNCTION register_for_event(request, response):
    event_id = request.params.id
    attendee_id = request.user.id
    
    DB.start_transaction()
    
    // 1. Fetch Event Info
    event = DB.query("SELECT capacity FROM Events WHERE id = ?", [event_id])
    
    // 2. Count Current Registrations (With Lock)
    current_count = DB.query("SELECT count(*) FROM Registrations WHERE event_id = ? AND status != 'cancelled' FOR UPDATE", [event_id])
    
    // 3. Enforce Capacity
    IF current_count >= event.capacity:
        DB.rollback()
        RETURN 409 "Event is sold out"
        
    // 4. Prevent Double Registration
    existing = DB.query("SELECT id FROM Registrations WHERE event_id = ? AND attendee_id = ?", [event_id, attendee_id])
    IF existing:
        DB.rollback()
        RETURN 400 "You are already registered"
        
    // 5. Create Ticket
    ticket_id = generate_uuid()
    DB.insert("Registrations", { id: ticket_id, event_id, attendee_id, status: 'registered' })
    
    DB.commit()
    
    // Mock Email Send
    trigger_email(request.user.email, "Your Ticket", ticket_id)
    
    RETURN 201 { ticket_id: ticket_id }
```

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

## 🧪 Testing: How to Verify

### Test 1: Capacity Limit
- Create an event with `capacity: 2`.
- Register Attendee 1 (Success).
- Register Attendee 2 (Success).
- Register Attendee 3 (Fails with 409).
- Cancel Attendee 1's ticket.
- Register Attendee 3 again (Success!).

### Test 2: Check-In Validation
- As the Organizer, hit the Check-In endpoint with a valid ticket ID. (Success).
- Hit the Check-In endpoint again with the same ticket ID. (Should return an error: "Already checked in").

---

## 📚 Resources

- **Transactions**: Look up "Database row locking" (e.g., `SELECT ... FOR UPDATE`).
- **QR Codes**: You can easily convert the `ticket_id` string into a physical QR code on the frontend later!

---

## ✅ Before Submission

- [ ] Does the system block registrations when the capacity limit is hit?
- [ ] Are cancelled tickets properly excluded from the capacity count?
- [ ] Can an organizer ONLY check-in tickets for events they created?
- [ ] Is double-registration (one user registering twice for the same event) prevented?

---

**Build this and learn: Capacity constraints, ticket states, and strict ownership validation.**
