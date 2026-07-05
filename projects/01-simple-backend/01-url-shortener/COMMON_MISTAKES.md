# 🔗 URL Shortener: Learn By Building

**"Build a system that takes long, ugly URLs and turns them into short, shareable links, tracking how many times they are clicked."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Returning JSON instead of Redirecting

**Wrong:**
```javascript
app.get('/:shortCode', async (req, res) => {
  const url = await db.query("SELECT * FROM urls WHERE short_code = ?", req.params.shortCode);
  
  // The user clicked the link expecting to go to YouTube, but instead they see a JSON screen!
  res.json({ target: url.original_url }); 
});
```

**Right:**
```javascript
app.get('/:shortCode', async (req, res) => {
  const url = await db.query("SELECT * FROM urls WHERE short_code = ?", req.params.shortCode);
  
  // Actually redirect the browser
  res.redirect(302, url.original_url);
});
```

### ❌ Mistake 2: Blocking the Redirect with Analytics

**Wrong:**
```javascript
app.get('/:shortCode', async (req, res) => {
  const url = await db.query("...");
  
  // We make the user wait while we write to the database!
  await db.query("UPDATE urls SET clicks = clicks + 1 WHERE id = ?", url.id);
  await db.insert("click_analytics", { ... });
  
  res.redirect(302, url.original_url);
});
```
*Why it's bad:* Database writes take time. If the DB is slow, the user is staring at a blank screen waiting for the redirect. The user doesn't care about your analytics!

**Right:**
```javascript
app.get('/:shortCode', async (req, res) => {
  const url = await db.query("...");
  
  // 1. Redirect IMMEDIATELY
  res.redirect(302, url.original_url);
  
  // 2. Fire and forget the database writes (Notice: NO "await" keyword!)
  // In a real system, you might put this in a Redis queue, but removing await is a good start.
  db.query("UPDATE urls SET clicks = clicks + 1 WHERE id = ?", url.id).catch(console.error);
  db.insert("click_analytics", { ... }).catch(console.error);
});
```

### ❌ Mistake 3: Vulnerability to SQL Injection or XSS

**Wrong:**
```javascript
// A malicious user submits a script instead of a URL
const badUrl = "javascript:alert('Hacked!');";
db.insert("urls", { original_url: badUrl, short_code: "hck" });
```
*Why it's bad:* If someone visits `short.ly/hck`, the browser might execute the javascript instead of navigating to a webpage.

**Right:**
```javascript
// Validate that it's a real HTTP/HTTPS URL before saving
try {
  const parsed = new URL(req.body.original_url);
  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
    throw new Error('Invalid protocol');
  }
} catch (err) {
  return res.status(400).json({ error: "Invalid URL" });
}
```

### ❌ Mistake 4: Generating Predictable Short Codes

**Wrong:**
```javascript
// Base62 encoding the auto-incrementing ID
// ID 1 -> 'b'
// ID 2 -> 'c'
```
*Why it's bad:* A competitor can script a bot to visit `short.ly/b`, `short.ly/c`, `short.ly/d`, and easily steal/scrap every single URL your users have ever created. They also instantly know exactly how many links your business has processed.

**Right:**
Use a cryptographically secure random string generator (like `nanoid` or `crypto.randomBytes`).
```javascript
const { nanoid } = require('nanoid');
const shortCode = nanoid(7); // e.g., 'V1StGXR'
```

---
