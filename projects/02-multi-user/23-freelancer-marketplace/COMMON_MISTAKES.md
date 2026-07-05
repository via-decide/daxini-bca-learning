# 💼 Freelancer Marketplace API: Learn By Building

**"Build a multi-user API where Clients post freelance jobs, Freelancers bid on those jobs, and Clients accept a bid to initiate a contract."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Not Validating Project State During Bid Acceptance

**Wrong:**
```javascript
// A client accepts a bid
app.put('/api/bids/:id/accept', async (req, res) => {
  // Update the bid to accepted
  await db.query("UPDATE bids SET status = 'accepted' WHERE id = ?", req.params.id);
  
  // Update the project to in_progress
  const bid = await db.query("SELECT project_id FROM bids WHERE id = ?", req.params.id);
  await db.query("UPDATE projects SET status = 'in_progress' WHERE id = ?", bid.project_id);
});
```
*Why it's bad:* If the client triggers this endpoint twice (for two different bids), the database will happily update both bids to 'accepted', and update the project to 'in_progress' twice. The client now has two contracts for one job.

**Right:**
Use the Project's state as a lock within a transaction.
```javascript
const result = await db.query(
  "UPDATE projects SET status = 'in_progress' WHERE id = ? AND status = 'open'", 
  projectId
);
if (result.affectedRows === 0) throw new Error("Project is already closed.");
```

### ❌ Mistake 2: Missing Cleanup (Leaving Bids 'Pending')

**Wrong:**
When a bid is accepted, leaving all other competing bids as 'pending' in the database.

*Why it's bad:* The other freelancers will wait forever thinking they still have a chance. Your UI will show weird states.

**Right:**
Inside your acceptance transaction, explicitly reject the losers.
```sql
UPDATE bids SET status = 'rejected' WHERE project_id = ? AND id != ?
```

### ❌ Mistake 3: Weak Authentication Checks for Bids

**Wrong:**
Allowing anyone to `GET /api/bids/:id` and returning the bid amount and proposal text.

*Why it's bad:* Freelancers can scrape this endpoint by guessing IDs to see what their competitors are bidding, destroying the marketplace dynamics.

**Right:**
Only return bid details if `req.user.id == bid.freelancer_id` OR `req.user.id == project.client_id`.

---
