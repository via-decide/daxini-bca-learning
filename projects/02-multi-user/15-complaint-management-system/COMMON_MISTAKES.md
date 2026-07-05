# 📝 Complaint Management System: Learn By Building

**"Build a multi-user API for a city or large organization where Citizens submit complaints (like Potholes), and City Workers claim, update, and resolve those complaints via a strict state machine."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Not enforcing the "Previous State"

**Wrong:**
```javascript
app.put('/api/complaints/:id/resolve', async (req, res) => {
  // Blindly updating the status just because a worker asked to
  await db.query("UPDATE complaints SET status = 'resolved' WHERE id = ?", req.params.id);
});
```
*Why it's bad:* A worker could accidentally click "Resolve" on a complaint that was just submitted 5 seconds ago ('open'), skipping the 'in_progress' phase entirely. This ruins the city's metrics on how long it actually takes to fix things.

**Right:**
Always verify the *current* state before allowing a transition.
```javascript
app.put('/api/complaints/:id/resolve', async (req, res) => {
  const result = await db.query(`
    UPDATE complaints SET status = 'resolved' 
    WHERE id = ? AND status = 'in_progress' AND worker_id = ?
  `, [req.params.id, req.user.id]);
  
  if (result.changes === 0) throw new Error("Invalid state transition or unauthorized.");
});
```

### ❌ Mistake 2: Hard Deletions (CASCADE) on Public Data

**Wrong:**
```sql
FOREIGN KEY (citizen_id) REFERENCES users(id) ON DELETE CASCADE
```
*Why it's bad:* If an angry citizen deletes their app account, the database automatically deletes the 15 potholes they reported. The city will never fix them because the data evaporated.

**Right:**
Use `ON DELETE SET NULL`. The user's personal data is gone (their name/email), but the civic data (the pothole location) remains intact for the city to fix.

### ❌ Mistake 3: Allowing users to update the status via generic endpoints

**Wrong:**
```javascript
// A generic update endpoint where the frontend passes the entire object
app.put('/api/complaints/:id', (req, res) => {
  db.query("UPDATE complaints SET title=?, description=?, status=? WHERE id=?", 
    [req.body.title, req.body.description, req.body.status, req.params.id]);
});
```
*Why it's bad:* A hacker can send `{ status: "closed" }` and close their own pothole complaint instantly.

**Right:**
Use specific, intent-driven endpoints (`/claim`, `/resolve`, `/close`) that hardcode the status changes on the server side. Never let the client dictate the state.

---
