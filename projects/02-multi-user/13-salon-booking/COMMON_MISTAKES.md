# ✂️ Salon Booking API: Learn By Building

**"Build a scheduling API for a salon where Customers book distinct Services (like Haircuts or Coloring) with specific Stylists, managing varying service durations and preventing overlap."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Relying on Frontend Date/Time Calculations

**Wrong:**
```javascript
// The frontend calculates that 10:00 + 120 mins = 12:00, and sends it to the API
app.post('/api/appointments', async (req, res) => {
  await db.query("INSERT INTO appointments (...) VALUES (?, ?)", [req.body.start_time, req.body.end_time]);
});
```
*Why it's bad:* A malicious user (or a frontend bug) could book a $150 Hair Coloring service (which normally takes 2 hours), but send an `end_time` of `10:05`. They just blocked off only 5 minutes of the stylist's time, allowing someone else to double-book the stylist, creating chaos in the salon.

**Right:**
The server must ALWAYS independently fetch the `duration_minutes` from the database and calculate the `end_time` itself.

### ❌ Mistake 2: Bad Overlap SQL Logic

**Wrong:**
```sql
-- Checking if the NEW start time is exactly equal to an OLD start time
SELECT * FROM appointments 
WHERE start_time = ? OR end_time = ?
```
*Why it's bad:* If I have an appointment from 10:00 to 12:00, and you try to book from 10:30 to 11:30, your query will say "No overlap found!" because `10:30 != 10:00`.

**Right:**
Use the Universal Overlap Formula: `(NewStart < OldEnd) AND (NewEnd > OldStart)`.

### ❌ Mistake 3: Missing the Junction Table

**Wrong:**
Adding a `service_id` column directly to the `Users` (Stylist) table.
*Why it's bad:* A stylist can only offer one single service. If they learn how to do both Haircuts and Coloring, your database schema breaks.

**Right:**
Use a Many-to-Many junction table (`stylist_services`).

---
