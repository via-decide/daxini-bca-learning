# 👔 Project Management System: Learn By Building

**"Build a multi-user project board (like Jira or Trello) where Managers create projects, Assignees move tasks across columns, and Watchers receive updates, requiring complex multi-table relationships."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Manual Cascading Deletes in Application Code

**Wrong:**
```javascript
app.delete('/api/projects/:id', async (req, res) => {
  // Try to clean up children manually
  const tickets = await db.query("SELECT id FROM tickets WHERE project_id = ?", req.params.id);
  for (let t of tickets) {
    await db.query("DELETE FROM comments WHERE ticket_id = ?", t.id);
    await db.query("DELETE FROM tickets WHERE id = ?", t.id);
  }
  await db.query("DELETE FROM projects WHERE id = ?", req.params.id);
});
```
*Why it's bad:* If your Node server crashes in the middle of this loop, you are left with a permanently corrupted database. It's also extremely slow (N queries).

**Right:**
Use `ON DELETE CASCADE` in your database schema. Then your code is just:
```javascript
app.delete('/api/projects/:id', async (req, res) => {
  // The database handles deleting all 10,000 tickets and 50,000 comments automatically, instantly, and safely.
  await db.query("DELETE FROM projects WHERE id = ?", req.params.id);
});
```

### ❌ Mistake 2: Missing Data Grouping (Lazy APIs)

**Wrong:**
```javascript
// Returning flat data
const tickets = await db.query("SELECT * FROM tickets WHERE project_id = 1");
res.json({ tickets: tickets }); // Returns a flat array of 50 tickets
```
*Why it's bad:* The frontend is building a Kanban board with 4 columns. If you send a flat array, the frontend has to write heavy Javascript `filter()` loops to figure out which column each ticket belongs in.

**Right:**
Format the data for the consumer.
```javascript
const grouped = { to_do: [], in_progress: [], review: [], done: [] };
for (let t of tickets) {
  grouped[t.status].push(t);
}
res.json({ tickets: grouped });
```

### ❌ Mistake 3: Storing Statuses as Free Text

**Wrong:**
```sql
CREATE TABLE tickets (
  status TEXT
);
```
*Why it's bad:* A user can insert `status = 'almost done'` or `status = 'To DO'`. Your frontend board only knows how to render 4 specific columns. Any typo will break the UI completely.

**Right:**
Use Enums or strict DB `CHECK` constraints.
```sql
status TEXT CHECK (status IN ('to_do', 'in_progress', 'review', 'done'))
```

---
