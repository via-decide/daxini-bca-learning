# 💻 Code Snippet Storage API: Learn By Building

**"Build a pastebin-like API where developers can upload text (code snippets), optionally set them to self-destruct after viewing, and retrieve them with a unique ID."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Using Sequential Auto-Incrementing IDs

**Wrong:**
```javascript
// Database creates IDs like 1, 2, 3, 4
const id = insertIntoDb(content);
const url = `http://myapi.com/snippets/${id}`; // http://myapi.com/snippets/5
```
*Why it's bad:* If I upload a private snippet and get ID `100`, I immediately know that IDs `1` through `99` exist. I can write a script to scrape all 100 private snippets. This is called an **Insecure Direct Object Reference (IDOR)** vulnerability.

**Right:**
Use short, random strings (e.g., using the `nanoid` library).
```javascript
const { nanoid } = require('nanoid');
const id = nanoid(8); // e.g. "V1StGXR8"
```
Even if someone knows your ID is 8 characters long, it would take a computer centuries to guess a valid URL.

### ❌ Mistake 2: The "Read then Delete" Race Condition

**Wrong:**
```javascript
const snippet = await db.query("SELECT * FROM snippets WHERE id = ?", id);
if (snippet.is_burn_after_reading) {
  await db.query("DELETE FROM snippets WHERE id = ?", id);
}
res.json(snippet);
```
*Why it's bad:* As explained in the Architecture doc, if two requests hit this code at the exact same millisecond, both will pass the `SELECT` check before either hits the `DELETE` step.

**Right (PostgreSQL example using RETURNING):**
```sql
-- This does it all in one atomic step
DELETE FROM snippets WHERE id = $1 RETURNING *;
```
**Right (SQLite/General example using Transactions or Delete-First):**
```javascript
// Example: Delete it first! If the delete affects 1 row, we know WE got it.
// Wait, if we delete it first, how do we return the content?
// In SQLite, you can query, then delete within a TRANSACTION to lock the row.
```

### ❌ Mistake 3: Allowing Infinite Uploads

**Wrong:**
```javascript
app.post('/api/snippets', (req, res) => {
  db.insert(req.body);
});
```
*Why it's bad:* A malicious bot can send a `for` loop of 1 million requests to your server, instantly filling up your hard drive and crashing your database.

**Right:**
Use a middleware like `express-rate-limit`.
```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use('/api/snippets', limiter);
```

---
