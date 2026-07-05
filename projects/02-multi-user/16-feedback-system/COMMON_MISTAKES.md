# 🗣️ Customer Support Feedback System: Learn By Building

**"Build a multi-user API where Customers leave reviews for specific Support Agents, and Admins view aggregated performance scores to identify top employees."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Relying on Javascript to enforce the 1-to-1 rule

**Wrong:**
```javascript
app.post('/api/feedback', async (req, res) => {
  const existing = await db.query("SELECT * FROM feedback_reviews WHERE ticket_id = ?", ticket_id);
  
  if (existing.length > 0) return res.status(409).send("Already reviewed");
  
  // What if the user double-clicks the submit button really fast?
  await db.query("INSERT INTO feedback_reviews...");
});
```
*Why it's bad:* This is a Race Condition. If two HTTP requests arrive at the exact same millisecond, they both run the `SELECT` query, both see 0 existing reviews, and both run the `INSERT` query. You now have two reviews for one ticket.

**Right:**
Enforce it at the Database level using a `UNIQUE` constraint on the column. The database engine guarantees it will never insert a duplicate, regardless of how fast requests come in.

### ❌ Mistake 2: Calculating Averages in Javascript

**Wrong:**
```javascript
// Fetching all data to calculate the average
const reviews = await db.query("SELECT rating FROM feedback_reviews WHERE agent_id = ?", agentId);
const total = reviews.reduce((sum, r) => sum + r.rating, 0);
const average = total / reviews.length;
```
*Why it's bad:* If an agent has 10,000 reviews, you just sent 10,000 rows across the network and loaded them into your server's RAM just to get a single number.

**Right:**
Use SQL to do the math. `SELECT AVG(rating) FROM feedback_reviews WHERE agent_id = ?` returns a single number instantly.

### ❌ Mistake 3: Over-Normalization

**Wrong:**
Not putting `agent_id` in the `feedback_reviews` table because "you can figure it out by joining the `support_tickets` table."

*Why it's bad:* While technically true (Normalization), if you want to generate a leaderboard of all agents, having to constantly `JOIN` the tickets table just to figure out who the review was for is computationally expensive.

**Right:**
Use controlled Denormalization. Storing the `agent_id` directly on the review makes analytics queries blazing fast.

---
