# ⏱️ Time Tracking API: Learn By Building

**"Build a multi-user API where freelancers log hours against client projects, generating automated invoices and tracking real-time productivity."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Relying on the Client (Frontend) Clock

**Wrong:**
```javascript
// The frontend sends the duration it counted
app.post('/api/time/log', (req, res) => {
  db.query("INSERT INTO time_entries (duration) VALUES (?)", req.body.duration);
});
```
*Why it's bad:* Users can easily hack the frontend to send `{ duration: 99999 }` and bill their clients for a million dollars. Also, if their browser crashes, the timer is lost forever.

**Right:**
The server is the only source of truth for time. The frontend just sends a "Start" and "Stop" signal.
```javascript
app.post('/api/time/start', (req, res) => {
  db.query("INSERT INTO time_entries (start_time) VALUES (CURRENT_TIMESTAMP)");
});
```

### ❌ Mistake 2: Missing the `user_id` on the lowest table

**Wrong:**
```sql
CREATE TABLE time_entries (
  id TEXT PRIMARY KEY,
  project_id TEXT -- Only linking to project
);
```
*Why it's bad:* If I want to find "all time entries for User 123", the database has to join `time_entries` -> `projects` -> `clients` -> `users` just to check ownership. This is very slow.

**Right:**
Add a redundant `user_id` to the `time_entries` table. This is called **Denormalization**. It allows you to instantly fetch a user's time entries without joining 3 tables.
```sql
CREATE TABLE time_entries (
  id TEXT PRIMARY KEY,
  project_id TEXT,
  user_id TEXT -- Makes querying 100x faster!
);
```

### ❌ Mistake 3: Doing Aggregation in Node.js

**Wrong:**
```javascript
// Fetch 10,000 time entries into RAM
const entries = await db.query("SELECT * FROM time_entries");

let totalOwed = 0;
for (let entry of entries) {
   const duration = entry.end_time - entry.start_time;
   totalOwed += duration * entry.hourly_rate;
}
```
*Why it's bad:* Transferring 10,000 rows across the network and doing math in Javascript is incredibly slow and wastes massive amounts of server RAM.

**Right:**
Use SQL `SUM()` and math operators. The DB does it instantly and returns a single number.

---
