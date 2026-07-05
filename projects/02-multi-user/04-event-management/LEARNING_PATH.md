# 🎟️ Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage ticket sales, and attendees can browse and register for events."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Concurrency & Race Conditions** - The most important concept in e-commerce: preventing overbooking when multiple people buy at the same time.  
✅ **Database Transactions** - Ensuring multi-step financial operations (create registration + generate tickets + update capacity) succeed or fail as a single unit.  
✅ **Database Constraints** - Using `CHECK` constraints to enforce business logic at the lowest level.  
✅ **Role-Based Access Control (RBAC)** - Separating Organizer and Attendee privileges.  
✅ **Secure Identifier Generation** - Creating unguessable QR codes/tokens for real-world verification.  
✅ **Relational Data Modeling** - Connecting Users, Events, Tiers, Registrations, and Tickets.

---

## 📋 Project Overview

### The Problem

Handling ticketing for events sounds simple until 500 people try to buy the last 100 tickets simultaneously. A naive system will sell 500 tickets, leaving the organizer with a disastrous overbooking situation. Additionally, a system must generate secure, unique tickets that cannot be forged at the door.

**Your job:** Build a bulletproof backend for creating events and selling tickets securely.

### Who Uses It

```
Organizer (Creator):
├─ Create Events (Title, Date, Location)
├─ Create Ticket Tiers (VIP=100, General=500)
├─ View Attendee list
└─ Scan/Check-in tickets at the door

Attendee (Customer):
├─ Browse and search upcoming events
├─ Purchase tickets (Registration)
├─ View purchased tickets/QR codes
└─ Present ticket at the door
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Create Event (Organizer)

```pseudocode
POST /api/organizer/events(title, date, location, tiers):
  Step 1: Authenticate
    Verify JWT token -> get user_id, role
    if role != 'organizer': return error 403
    
  Step 2: Create Event
    START TRANSACTION:
      event_id = database.insert("events", { title, date, location, organizer_id: user_id })
      
      foreach tier in tiers:
        database.insert("ticket_tiers", { 
          event_id, 
          name: tier.name, 
          price: tier.price, 
          capacity: tier.capacity 
        })
    COMMIT
    
  Step 3: Return success
    return { event_id, status: 'success' }
```

### 2. Buy Tickets (The Complex Part)

```pseudocode
POST /api/events/:id/register(tier_id, quantity):
  Step 1: Authenticate
    Verify JWT token -> get user_id
    
  Step 2: The Concurrent Purchase
    START TRANSACTION:
    
      // 1. Attempt to update capacity atomically
      // The DB CHECK constraint (sold_count <= capacity) protects us here
      try:
        database.execute(`
          UPDATE ticket_tiers 
          SET sold_count = sold_count + ? 
          WHERE id = ? AND event_id = ?
        `, quantity, tier_id, event_id)
      catch constraint_error:
        ROLLBACK
        return error 409 "Tickets sold out or requested quantity exceeds capacity"
      
      // 2. Fetch the tier price to calculate total
      tier = database.query("SELECT price FROM ticket_tiers WHERE id = ?", tier_id)
      total_amount = tier.price * quantity
      
      // 3. Create the Registration/Order
      reg_id = database.insert("registrations", { 
        event_id, user_id, total_amount, payment_status: 'completed' 
      })
      
      // 4. Generate the individual tickets
      generated_tickets = []
      for i = 1 to quantity:
        secure_qr = generateRandomSecureString(16)
        ticket_id = database.insert("tickets", { 
          registration_id: reg_id, tier_id, qr_code: secure_qr 
        })
        generated_tickets.push(secure_qr)
        
    COMMIT
    
  Step 3: Return tickets to user
    return { registration_id: reg_id, tickets: generated_tickets }
```

### 3. Scan Ticket at the Door (Organizer)

```pseudocode
POST /api/organizer/tickets/:qr_code/checkin:
  Step 1: Authenticate
    Verify JWT -> user_id, role
    
  Step 2: Find Ticket
    ticket = database.query(`
      SELECT t.id, t.status, e.organizer_id 
      FROM tickets t
      JOIN ticket_tiers tt ON t.tier_id = tt.id
      JOIN events e ON tt.event_id = e.id
      WHERE t.qr_code = ?
    `, qr_code)
    
    if not ticket: return error 404 "Ticket not found"
    
  Step 3: Verify Ownership
    if ticket.organizer_id != user_id:
      return error 403 "You are not the organizer for this event"
      
  Step 4: Verify Status
    if ticket.status == 'checked_in':
      return error 400 "Ticket already used!"
      
  Step 5: Check-in
    database.update("tickets", ticket.id, { 
      status: 'checked_in', 
      checked_in_at: NOW() 
    })
    
    return success "Valid ticket, user checked in"
```

---

## ✅ Before Submission

- [ ] Organizers can create events and set ticket capacities.
- [ ] Attendees can purchase tickets.
- [ ] Overbooking is mathematically impossible due to DB locking/constraints.
- [ ] Tickets generate unique, unguessable QR code strings.
- [ ] Organizers can scan a ticket and mark it 'checked_in'.
- [ ] Scanning a ticket twice results in an error.
- [ ] An organizer cannot scan tickets for an event they didn't create.
- [ ] Database transactions are used for all multi-step writes.
- [ ] Code is on GitHub

**Success:** A robust, concurrency-safe ticketing engine that could handle a real-world flash sale.
