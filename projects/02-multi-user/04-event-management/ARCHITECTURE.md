# 🎟️ Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage ticket sales, and attendees can browse and register for events."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. An organizer creates an event: "Tech Conference 2026" with 500 VIP tickets and 2000 General tickets.
2. A user browses upcoming events and filters by category (Technology, Music, Sports).
3. A user decides to buy 2 VIP tickets to the Tech Conference.
4. The system needs to ensure it doesn't sell 501 VIP tickets (overbooking).
5. The user gets a unique ticket QR code/ID.
6. On the day of the event, the organizer scans the ticket to check the user in.

**What data do you need for each?**

After thinking, here's the data model:

```
Users (for login - both organizers and attendees)
├─ id (UUID)
├─ email (unique)
├─ password_hash
├─ name
├─ role (organizer / attendee)
└─ created_at

Events (the main entity)
├─ id (UUID)
├─ organizer_id (links to Users)
├─ title
├─ description
├─ location (venue name or virtual link)
├─ start_time
├─ end_time
├─ category (Technology, Music, etc.)
├─ status (draft / published / cancelled)
└─ created_at

Ticket_Tiers (types of tickets available for an event)
├─ id (UUID)
├─ event_id (links to Events)
├─ name (e.g., "VIP", "Early Bird", "General")
├─ price (decimal)
├─ capacity (total tickets available)
└─ sold_count (how many have been sold)

Registrations (an order placed by a user)
├─ id (UUID)
├─ event_id (links to Events)
├─ user_id (links to Users)
├─ total_amount (decimal)
├─ payment_status (pending / completed / failed)
└─ created_at

Tickets (individual tickets generated from a registration)
├─ id (UUID)
├─ registration_id (links to Registrations)
├─ tier_id (links to Ticket_Tiers)
├─ qr_code (unique string)
├─ status (valid / checked_in / cancelled)
└─ checked_in_at (timestamp)
```

---

### Step 2: The Concurrency Problem (Overbooking)

**Question: If an event has 1 ticket left, and two users click "Buy" at the exact same millisecond, how do you prevent selling 2 tickets?**

**Bad Idea (Read-then-Write):**
```javascript
// User A and User B both run this at exactly 10:00:00.000
const tier = db.query("SELECT capacity, sold_count FROM ticket_tiers WHERE id = 1");

if (tier.sold_count < tier.capacity) {
  // Both see 99 sold out of 100 capacity (1 left)
  // Both insert a ticket
  db.insert("tickets", { ... });
  // Both update the count to 100
  db.query("UPDATE ticket_tiers SET sold_count = sold_count + 1");
}
// Result: 101 tickets sold! OVERBOOKING!
```

**Good Idea (Database Locks / Constraints):**
```sql
-- Tell the database to lock the row while we look at it
BEGIN TRANSACTION;
SELECT * FROM ticket_tiers WHERE id = 1 FOR UPDATE;
-- Now User B must wait until User A finishes their transaction!
```
*Or, use a CHECK constraint in the database:*
```sql
ALTER TABLE ticket_tiers ADD CONSTRAINT check_capacity CHECK (sold_count <= capacity);
-- If User B tries to update sold_count to 101, the database throws an error.
```

**Decision:** We must use Database Transactions and row-level locking (or constraints) for the ticketing process.

---

### Step 3: Database Architecture

```
┌──────────────────────────────────────────┐
│              Database                    │
├──────────────────────────────────────────┤
│                                          │
│  users ─────────┐                        │
│                 │                        │
│                 ├──► events ────────┐    │
│                 │       │           │    │
│                 │       ▼           ▼    │
│                 │  ticket_tiers  registrations
│                 │       │           │    │
│                 │       └─────► tickets ◄┘
│                                          │
└──────────────────────────────────────────┘

Relationships:
- users.id → events.organizer_id (one user, many events)
- events.id → ticket_tiers.event_id (one event, many ticket tiers)
- users.id → registrations.user_id (one user, many registrations)
- events.id → registrations.event_id (one event, many registrations)
- registrations.id → tickets.registration_id (one registration, many individual tickets)
- ticket_tiers.id → tickets.tier_id (one tier, many individual tickets)
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML)             │
│  ┌──────────────────────────────────────┐  │
│  │ Organizer Dashboard (Create event)   │  │
│  │ Public Event Browser                 │  │
│  │ Event Detail & Checkout Page         │  │
│  │ User Wallet (My Tickets)             │  │
│  │ Scanner App (Check-in UI)            │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP Requests
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ Authentication (JWT)                 │  │
│  ├──────────────────────────────────────┤  │
│  │ API Endpoints                        │  │
│  │  - Events CRUD (Organizer only)      │  │
│  │  - Search/Filter Events (Public)     │  │
│  │  - Ticket Purchasing (Concurrency!)  │  │
│  │  - QR Code Check-in (Organizer only) │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        SQL Queries (with Transactions)
              │
              ▼
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent data storage                 │
│  - CHECK constraints (sold <= capacity)    │
└────────────────────────────────────────────┘
```

---
