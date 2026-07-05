# 🏥 Hospital Management System: Learn By Building

**"Build a multi-user platform where Doctors can view their appointments, Receptionists can book patients, and Administrators can manage hospital resources, all backed by a relational database."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Trusting the Client for Authorization

**Wrong:**
```javascript
// The client sends { role: 'admin' } in the body to prove they are an admin
app.delete('/api/users/:id', (req, res) => {
  if (req.body.role !== 'admin') return res.status(403).send("Forbidden");
  
  db.query("DELETE FROM users WHERE id = ?", req.params.id);
});
```
*Why it's bad:* A hacker can just open Postman and type `"role": "admin"` in their JSON body. Never trust data coming from the frontend for security.

**Right:**
Extract the role from the cryptographically signed JWT token (which the user cannot tamper with).
```javascript
app.delete('/api/users/:id', (req, res) => {
  // req.user is populated by verifying the JWT signature
  if (req.user.role !== 'admin') return res.status(403).send("Forbidden");
});
```

### ❌ Mistake 2: The N+1 Query Problem

**Wrong:**
```javascript
// Get all appointments (1 query)
const appointments = await db.query("SELECT * FROM appointments");

// Loop through them and get patient names (N queries)
for (let apt of appointments) {
  const patient = await db.query("SELECT full_name FROM patients WHERE id = ?", apt.patient_id);
  apt.patient_name = patient.full_name;
}
res.json(appointments);
```
*Why it's bad:* If there are 1,000 appointments, your server just made 1,001 separate requests to the database. This will crush your database performance.

**Right:**
Use a single SQL `JOIN` query to let the database combine the data efficiently in milliseconds.
```sql
SELECT a.*, p.full_name 
FROM appointments a 
JOIN patients p ON a.patient_id = p.id;
```

### ❌ Mistake 3: Double Booking (Concurrency)

**Wrong:**
```javascript
// Check if doctor is free
const existing = await db.query("SELECT * FROM appointments WHERE doctor_id = ? AND date = ?", [docId, date]);
if (existing.length === 0) {
  // Book it
  await db.query("INSERT INTO appointments ...");
}
```
*Why it's bad:* If two receptionists click "Book" at the exact same millisecond, they both check the DB, see it's free, and both insert a row.

**Right:**
Add a `UNIQUE` constraint to the database table itself: `UNIQUE(doctor_id, appointment_date)`. The database will physically reject the second insert, preventing double bookings forever.

---
