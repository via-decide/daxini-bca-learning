# 📚 Tutoring Platform API: Learn By Building

**"Build a multi-user API where Tutors define their availability slots, and Students book sessions using those slots without causing double-bookings."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Client-Side Timezone Trust

**Wrong:**
The frontend sends `{"date": "2026-10-15", "time": "10:00 AM", "timezone": "EST"}` and the backend tries to parse it, store the timezone string, and do math on it later.

**Right:**
The Database ONLY stores UTC. The Backend ONLY expects UTC. 
The Frontend uses Javascript (`new Date().toISOString()`) to convert local time to UTC *before* sending the request. 

### ❌ Mistake 2: Missing the Atomic Lock on Bookings

**Wrong:**
```javascript
// A student tries to book a slot
app.post('/api/slots/:id/book', async (req, res) => {
  const slot = await db.query("SELECT is_booked FROM availability_slots WHERE id = ?", req.params.id);
  
  if (!slot.is_booked) {
    // RACE CONDITION! Someone else might have booked it right here!
    await db.query("INSERT INTO bookings...");
    await db.query("UPDATE availability_slots SET is_booked = true...");
  }
});
```
*Why it's bad:* This is the classic double-booking bug.

**Right:**
Use the `UPDATE` query itself as the lock, or use a Partial Unique Index in your database.
```sql
CREATE UNIQUE INDEX idx_unique_confirmed ON bookings(slot_id) WHERE status = 'confirmed';
-- Now, if two INSERTs happen, the database will literally crash the second query, saving you from a double-booking.
```

### ❌ Mistake 3: Soft Deletes Breaking Constraints

**Wrong:**
You allow a booking to be cancelled, but you physically `DELETE` the row from the `bookings` table.

*Why it's bad:* You lose the history of the cancellation, which might be needed for refund policies or analytics.

**Right:**
Update the `status` to `'cancelled'`, and then update `availability_slots.is_booked = false` so it can be booked by someone else.

---
