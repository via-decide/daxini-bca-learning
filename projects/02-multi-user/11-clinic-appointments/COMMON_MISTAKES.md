# 🩺 Clinic Appointments API: Learn By Building

**"Build a scheduling API where Doctors define their weekly availability, and Patients book specific 15-minute time slots, requiring strict time-boundary logic and overlap prevention."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Pre-generating Empty Database Rows

**Wrong:**
```javascript
// When a doctor sets their schedule, a script runs to insert a million rows into the DB
for (let i=0; i<365; i++) {
  db.query("INSERT INTO empty_slots (doctor_id, date, time) VALUES (...)");
}
```
*Why it's bad:* What if the doctor decides to take next Friday off? You have to find and delete those rows. What if you need to look 2 years into the future? It wastes massive amounts of database space.

**Right:**
Calculate available slots dynamically in memory. The database only stores "Rules" (Schedules) and "Events" (Appointments).

### ❌ Mistake 2: Trusting the Frontend's Slot Validation

**Wrong:**
```javascript
app.post('/api/appointments', async (req, res) => {
  // Assuming the frontend only shows available slots, so we just save whatever they sent
  await db.query("INSERT INTO appointments (...) VALUES (...)");
});
```
*Why it's bad:* Two patients might open the app at the exact same time. They both see 09:15 available. They both click it. Your backend blindly saves both.

**Right:**
The backend must re-validate the slot at the exact moment of booking (Is it within the doctor's schedule? Does the unique index reject it?).

### ❌ Mistake 3: Timezone Chaos

**Wrong:**
Storing dates and times using the server's local timezone.
*Why it's bad:* If your server moves from New York to California, all appointments shift by 3 hours.

**Right:**
Store all Date/Time fields in standard formats (YYYY-MM-DD for Date, HH:MM:SS for Time) and ensure your database engine treats them agnostically, OR store everything in strict UTC.

---
