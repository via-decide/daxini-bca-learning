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


## ✅ Before Submission

- [ ] Does the system block registrations when the capacity limit is hit?
- [ ] Are cancelled tickets properly excluded from the capacity count?
- [ ] Can an organizer ONLY check-in tickets for events they created?
- [ ] Is double-registration (one user registering twice for the same event) prevented?

---

**Build this and learn: Capacity constraints, ticket states, and strict ownership validation.**
