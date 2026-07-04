# 🔗 URL Shortener: Learn By Building

**"Build a system that makes long URLs short. Understand every part."**

---


## ⚠️ Common Mistakes: What NOT to Do

### ❌ Mistake 1: Hardcoding Short Codes

**Wrong:**
```javascript
app.post('/api/shorten', (req, res) => {
  // BAD! User provides code each time
  const code = req.body.customCode;
  // Then just use it
});
```

**Problem:**
- No uniqueness guarantee
- User inputs matter too much
- Can't auto-generate

**Right:**
```javascript
// Generate code if not provided
const code = customCode || generateShortCode();
// Then validate it doesn't exist
```

---

### ❌ Mistake 2: No URL Validation

**Wrong:**
```javascript
app.post('/api/shorten', (req, res) => {
  const { longUrl } = req.body;
  // Just save it, no validation
  db.save(longUrl);
});
```

**Problem:**
- User sends invalid URL
- Redirect fails
- Database has garbage

**Right:**
```javascript
function isValidUrl(url) {
  try {
    new URL(url); // JavaScript built-in
    return true;
  } catch {
    return false;
  }
}

if (!isValidUrl(longUrl)) {
  return res.status(400).json({ error: 'Invalid URL' });
}
```

---

### ❌ Mistake 3: Checking Uniqueness After Insert

**Wrong:**
```javascript
db.insert(shortCode, longUrl); // Insert first
// Then check if exists
const exists = db.query(shortCode);
```

**Problem:**
- Two requests might use same code
- Race condition
- Database constraint violation

**Right:**
```javascript
// Check FIRST
const exists = db.query(`SELECT * FROM urls WHERE shortCode = ?`, [shortCode]);
if (exists) {
  return res.status(400).json({ error: 'Code exists' });
}
// THEN insert
db.insert(shortCode, longUrl);
```

**Even Better:**
```javascript
// Use database constraint: UNIQUE
// Database prevents duplicates at DB level
CREATE TABLE urls (
  shortCode TEXT UNIQUE NOT NULL
);
```

---

### ❌ Mistake 4: Not Handling Errors

**Wrong:**
```javascript
const result = db.query(shortCode);
res.json({ url: result.longUrl }); // What if not found?
```

**Problem:**
- Crashes if result is null
- User sees error without message

**Right:**
```javascript
const result = db.query(shortCode);
if (!result) {
  return res.status(404).json({ error: 'URL not found' });
}
res.json({ url: result.longUrl });
```

---

### ❌ Mistake 5: Storing Plain URLs

**Wrong:**
```javascript
const longUrl = req.body.longUrl;
db.insert(shortCode, longUrl); // Store as-is
```

**Problem:**
- Might contain malicious content
- XSS vulnerabilities
- Not sanitized

**Right:**
```javascript
const longUrl = req.body.longUrl;
if (!isValidUrl(longUrl)) {
  return res.status(400).json({ error: 'Invalid URL' });
}
// Optionally: sanitize/validate further
db.insert(shortCode, longUrl);
```

---
