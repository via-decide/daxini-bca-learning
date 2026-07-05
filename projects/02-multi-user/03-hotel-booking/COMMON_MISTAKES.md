# 🏨 Hotel Booking System: Learn By Building

**"Build a reservation backend where Users can search for available rooms, Staff can manage bookings, and Administrators can manage inventory, featuring real-time availability checks to prevent double-booking."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Incorrect Date Overlap Logic

**Wrong (Trying to manually check overlaps):**
```sql
SELECT * FROM bookings 
WHERE check_in_date = ? AND check_out_date = ?
```
*Why it's bad:* If I book Dec 1 to Dec 10, and you try to book Dec 5 to Dec 6, this query won't catch it because the exact dates don't match.

**Right (The Universal Overlap Formula):**
Two date ranges overlap IF AND ONLY IF: `(StartA < EndB) AND (EndA > StartB)`.
```sql
-- Give me all rooms that are NOT currently booked for these dates
SELECT * FROM rooms WHERE id NOT IN (
  SELECT room_id FROM bookings 
  WHERE check_in_date < ? -- User's requested check-out date
  AND check_out_date > ?  -- User's requested check-in date
  AND status IN ('pending', 'confirmed') -- Ignore cancelled bookings
)
```

### ❌ Mistake 2: Missing Database Transactions

**Wrong:**
```javascript
const isAvailable = await checkAvailability(room_id, dates);
if (isAvailable) {
  // If the server pauses here for 10 milliseconds, someone else can book it!
  await db.query("INSERT INTO bookings ...");
}
```
*Why it's bad:* In a busy hotel system, checking availability and inserting the booking must happen as a single, indivisible, atomic step. Otherwise, you get double bookings.

**Right:**
Wrap it in a SQL Transaction (or use strict DB constraints).
```sql
BEGIN TRANSACTION;
  -- Do checks...
  -- Do inserts...
COMMIT;
```

### ❌ Mistake 3: Floating Point Currency

**Wrong:**
```sql
-- In Database Schema
price_per_night FLOAT 
```
```javascript
// In Node.js
const total = room.price_per_night * nights; 
// Result: 100.10 * 3 = 300.29999999999995
```
*Why it's bad:* Computers cannot represent decimals perfectly in binary. Never use `FLOAT` or JavaScript `Number` types for money, or your financial reports will be wrong.

**Right:**
In the database, use `DECIMAL(10,2)` or store the price as an integer in Cents (e.g. `$100.00` is saved as `10000`).

---
