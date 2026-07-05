# 🎟️ Event Management System: Learn By Building

**"Build a platform where organizers can create events, manage ticket sales, and attendees can browse and register for events."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Ignoring Race Conditions when Selling Tickets

**Wrong:**
```javascript
// A simple Read-Modify-Write without locking
const tier = await db.query("SELECT * FROM ticket_tiers WHERE id = ?", tierId);

if (tier.sold_count + requestedQty > tier.capacity) {
  return res.status(400).json({ error: "Not enough tickets" });
}

// Another user could have bought tickets in the 10ms between the SELECT and UPDATE!
await db.query("UPDATE ticket_tiers SET sold_count = sold_count + ? WHERE id = ?", [requestedQty, tierId]);
```
*Why it's bad:* This is a classic race condition. Under high load (like a popular concert going on sale), multiple users will read the same `sold_count` simultaneously, and all of them will successfully buy the "last" ticket.

**Right:**
```javascript
// Rely on Database Constraints or Atomic Updates
try {
  // Update the count FIRST. If the database CHECK constraint fails, this throws an error.
  await db.query(`
    UPDATE ticket_tiers 
    SET sold_count = sold_count + ? 
    WHERE id = ? AND (sold_count + ?) <= capacity
  `, [requestedQty, tierId, requestedQty]);
  
  // If no rows were affected, it means the WHERE clause failed (not enough capacity)
  // Proceed to create tickets...
} catch (err) {
  return res.status(409).json({ error: "Tickets sold out or unavailable" });
}
```

### ❌ Mistake 2: Missing Database Transactions

**Wrong:**
```javascript
// Creating a registration and generating tickets
const regId = await db.insert("registrations", { user_id, total });

// Server crashes or network fails right here!
for (let i = 0; i < qty; i++) {
  await db.insert("tickets", { registration_id: regId, qr_code: generateQR() });
}
// Result: The user paid for a registration, but no actual tickets exist in the system!
```

**Right:**
```javascript
// Use a transaction to ensure all-or-nothing
await db.transaction(async (trx) => {
  const regId = await trx.insert("registrations", { user_id, total });
  
  for (let i = 0; i < qty; i++) {
    await trx.insert("tickets", { registration_id: regId, qr_code: generateQR() });
  }
});
// Result: If it fails halfway, the entire operation is rolled back.
```

### ❌ Mistake 3: Guessable QR Codes / Ticket IDs

**Wrong:**
```javascript
// Generating a sequential or easily guessable ticket code
const ticketCode = `TICKET-${event_id}-${user_id}`;
```
*Why it's bad:* A malicious user could easily guess other people's ticket codes and generate fake QR codes to enter the event for free, checking in someone else's ticket.

**Right:**
```javascript
const crypto = require('crypto');
// Generate a highly secure, unguessable random string
const ticketCode = crypto.randomBytes(16).toString('hex');
```

### ❌ Mistake 4: Floating Point Math for Money

**Wrong:**
```javascript
// JavaScript floating point math is inaccurate
const price = 19.99;
const total = price * 3; // 59.96999999999999
```

**Right:**
```javascript
// Always calculate in cents (integers) to avoid rounding errors
const priceInCents = 1999;
const totalInCents = priceInCents * 3; // 5997
const displayTotal = totalInCents / 100; // 59.97
```

---
