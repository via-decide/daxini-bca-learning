# 🎟️ Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage ticket sales, and attendees can browse and register for events."**

---

## 🧪 Testing Scenarios

### Scenario 1: Basic Event Creation

```
1. Organizer logs in
2. Creates an event "Rock Concert"
3. Adds Ticket Tiers: "VIP" (100 capacity, $50) and "General" (500 capacity, $20)
4. Publishes event
5. Expected: Event appears in public listing GET /api/events
6. Verify: Attendee can view event details and see available tiers
```

### Scenario 2: Standard Ticket Purchase

```
1. Attendee logs in
2. Requests to buy 2 VIP tickets
3. Expected: API returns 201 Created with 2 QR codes
4. Verify: Database shows `sold_count = 2` for VIP tier
5. Verify: `registrations` table has 1 record for $100
6. Verify: `tickets` table has 2 records linked to the registration
```

### Scenario 3: Concurrency & Overbooking (The Stress Test)

```
1. Organizer creates an event with EXACTLY 1 ticket available.
2. Attendee A and Attendee B both run a script to POST to the buy endpoint at the EXACT same millisecond.
3. Expected: One user succeeds (201 Created).
4. Expected: The other user FAILS with a 409 Conflict ("Tickets sold out").
5. Verify: `sold_count` in database is 1, not 2.
6. Note: If both succeed, your transaction/locking logic is broken!
```

### Scenario 4: Ticket Check-In Workflow

```
1. Attendee presents their QR code (e.g., "VIP-123456")
2. Organizer hits POST /api/organizer/tickets/VIP-123456/checkin
3. Expected: Returns 200 OK "Check-in successful"
4. Organizer accidentally hits the endpoint a second time.
5. Expected: Returns 400 Bad Request "Ticket already checked in"
6. Attendee presents a fake QR code "FAKE-999"
7. Expected: Returns 404 Not Found "Ticket invalid"
```

### Scenario 5: Role Security

```
1. Attendee tries to POST /api/organizer/events (create an event)
2. Expected: 403 Forbidden "Only organizers can perform this action"
3. Organizer A tries to edit an event created by Organizer B
4. Expected: 403 Forbidden "You do not own this event"
```

---
