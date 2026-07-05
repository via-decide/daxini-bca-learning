# 🔗 Link Expiration System: Learn By Building

**"Build a secure link-sharing API that generates unique URLs that automatically expire after a certain number of clicks or a specific time limit."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Read-Modify-Write Race Conditions

**Wrong:**
```javascript
const link = db.query("SELECT * FROM links WHERE id = ?", id);
if (link.current_clicks < link.max_clicks) {
  // Update in memory
  db.query("UPDATE links SET current_clicks = ? WHERE id = ?", [link.current_clicks + 1, id]);
  res.redirect(link.target_url);
}
```
*Why it's bad:* If a teacher shares a link in a Zoom chat of 100 students, and the max clicks is 5, they will all click it at the exact same time. The database reads `0` for all 100 students, and allows all 100 through. 

**Right:**
Use atomic database updates and check the result of the update.
```javascript
// Add 1 in the DB atomically, AND ensure we don't exceed the max
const result = await db.query(
  "UPDATE links SET current_clicks = current_clicks + 1 WHERE id = ? AND (max_clicks IS NULL OR current_clicks < max_clicks)", 
  [id]
);

if (result.changes === 0) {
  // No rows were updated. It means the link didn't exist OR it hit the max limit.
  return res.status(410).json({ error: "Link expired or not found" });
}

// Now it's safe to redirect
```

### ❌ Mistake 2: Missing Protocol in the Target URL

**Wrong:**
```javascript
res.redirect('www.google.com'); 
```
*Why it's bad:* Express will think `www.google.com` is a relative path on your server, and will redirect the user to `http://localhost:3000/s/www.google.com`.

**Right:**
Validate the incoming URLs to ensure they start with `http://` or `https://` before saving them to the database.

### ❌ Mistake 3: Returning 404 instead of 410

**Wrong:**
If a link has expired, sending back a `404 Not Found`.

*Why it's bad:* A 404 implies the link never existed or was a typo. A user will keep refreshing thinking the server is broken.

**Right:**
Use HTTP status codes correctly. `410 Gone` explicitly tells the browser (and the user) that the resource *used* to exist, but is now permanently gone.

---
