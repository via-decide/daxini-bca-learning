# 🛡️ URL Safety Checker: Learn By Building

**"Build a security service that scans URLs against a database of known malicious domains to protect users from phishing and malware."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Relying on String `LIKE` Queries

**Wrong:**
```javascript
// A user submits: "https://badsite.com/login"
const url = req.body.url;

// Query the DB
const result = await db.query("SELECT * FROM blocked_domains WHERE ? LIKE '%' || domain || '%'", url);
```
*Why it's bad:* 
1. It completely bypasses your database indexes, doing a slow full-table scan.
2. False positives! If `bad.com` is in the blocklist, then `https://not-bad.com` will be incorrectly flagged as malicious because the string "bad.com" is inside it.

**Right:**
```javascript
// Always extract the exact hostname first
const urlObj = new URL(req.body.url);
let domain = urlObj.hostname;
if (domain.startsWith('www.')) domain = domain.slice(4);

// Do an exact, indexed lookup
const result = await db.query("SELECT * FROM blocked_domains WHERE domain = ?", domain);
```

### ❌ Mistake 2: Trusting User Input for URL Parsing

**Wrong:**
```javascript
const domain = req.body.url.split('/')[2]; 
// Assuming URL is always 'https://domain.com/path'
```
*Why it's bad:* If the user submits `http://domain.com` (no trailing slash), or `domain.com` (no protocol), your manual string splitting will fail and extract the wrong data or crash your server.

**Right:**
```javascript
// Use Node's built-in URL parser. It handles edge cases, ports, and protocols properly.
try {
  let urlStr = req.body.url;
  // Fallback if user just submitted "example.com" without protocol
  if (!urlStr.startsWith('http')) urlStr = 'http://' + urlStr;
  
  const parsedUrl = new URL(urlStr);
  const domain = parsedUrl.hostname;
} catch (e) {
  return res.status(400).json({ error: "Invalid URL" });
}
```

### ❌ Mistake 3: Storing "www." in the Database

**Wrong:**
```text
Table: blocked_domains
1. www.scam.com
2. phish.com
```
*Why it's bad:* If a user submits `http://scam.com` (without www), it will bypass the blocklist because it doesn't match `www.scam.com`.

**Right:**
Normalize all domains BEFORE inserting them into the database, and normalize them BEFORE querying. Always strip `www.`.
```javascript
function normalizeDomain(hostname) {
  return hostname.toLowerCase().replace(/^www\./, '');
}
```

### ❌ Mistake 4: Awaiting Analytics Before Responding

**Wrong:**
```javascript
app.post('/api/scan', async (req, res) => {
  const isSafe = await checkSafety(req.body.url);
  
  // Making the user wait for us to save the analytics log!
  await db.insert("scan_logs", { url: req.body.url, isSafe });
  
  res.json({ is_safe: isSafe });
});
```

**Right:**
```javascript
app.post('/api/scan', async (req, res) => {
  const isSafe = await checkSafety(req.body.url);
  
  // Respond instantly
  res.json({ is_safe: isSafe });
  
  // Fire and forget the log (no await)
  db.insert("scan_logs", { url: req.body.url, isSafe }).catch(console.error);
});
```

---
