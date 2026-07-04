# 🔗 URL Shortener: Learn By Building

**"Build a system that makes long URLs short. Understand every part."**

---


## 🧪 Testing: How to Verify It Works

### Test 1: Database Connection

**Before everything else:**
```
1. Start server: npm start
2. Should print: "Database connected"
3. If error: debug database setup
```

### Test 2: Create Short URL (Happy Path)

**Test this manually:**
```bash
curl -X POST http://localhost:3000/api/shorten \
  -H "Content-Type: application/json" \
  -d '{"longUrl": "https://wikipedia.org/wiki/AI"}'

Expected response:
{
  "shortCode": "aBcDeF",
  "shortUrl": "http://localhost:3000/aBcDeF",
  "longUrl": "https://wikipedia.org/wiki/AI"
}
```

**Questions:**
- Did it return a short code?
- Is the short code 6 characters?
- Can you access the database and find it?

### Test 3: Create with Invalid URL (Error Path)

**Test error handling:**
```bash
curl -X POST http://localhost:3000/api/shorten \
  -H "Content-Type: application/json" \
  -d '{"longUrl": "not a valid url"}'

Expected: 400 error with message
```

### Test 4: Redirect (The Main Feature)

**After creating a URL:**
```bash
curl -L http://localhost:3000/aBcDeF

Should redirect to original URL
```

**Without -L flag:**
```bash
curl http://localhost:3000/aBcDeF

Should return HTTP 302 with Location header
```

### Test 5: Check Clicks Incremented

**After visiting the short URL:**
```bash
curl http://localhost:3000/api/stats/aBcDeF

Expected:
{
  "shortCode": "aBcDeF",
  "clicks": 1,
  ...
}

Visit again:
{
  "shortCode": "aBcDeF",
  "clicks": 2,
  ...
}
```

### Test 6: Duplicate Custom Code

**Test uniqueness constraint:**
```bash
# First request
curl -X POST http://localhost:3000/api/shorten \
  -d '{"longUrl": "...", "customCode": "mycode"}'

Response: Success

# Second request with same code
curl -X POST http://localhost:3000/api/shorten \
  -d '{"longUrl": "...", "customCode": "mycode"}'

Expected: 400 error "Code already exists"
```

---


## 🐛 Debugging Guide: When Things Break

### Problem: "Server won't start"

**Debug steps:**
1. Check console output: what's the error?
2. Is port 3000 available? (Use different port)
3. Is database file writable? (Check permissions)
4. Are all imports correct? (npm install)

```javascript
// Add debugging
console.log('Starting server...');
console.log('Database:', db ? 'Connected' : 'Failed');
app.listen(PORT, () => console.log('Ready'));
```

### Problem: "POST /api/shorten returns 404"

**Root causes:**
1. Server not running (npm start)
2. Route path wrong (should be /api/shorten)
3. Method wrong (should be POST, not GET)
4. Middleware not set up (need body-parser)

**Debug:**
```javascript
// Log all requests
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

// Log request body
app.post('/api/shorten', (req, res) => {
  console.log('Request body:', req.body);
  // ...
});
```

### Problem: "Can't redirect: findUrl returns undefined"

**Root causes:**
1. shortCode not in database
2. Query is wrong
3. Database doesn't have rows
4. shortCode parameter not extracted

**Debug:**
```javascript
app.get('/:shortCode', (req, res) => {
  console.log('Looking for code:', req.params.shortCode);
  const result = db.query('SELECT * FROM urls WHERE shortCode = ?', [req.params.shortCode]);
  console.log('Found:', result);
  // Then use result
});
```

### Problem: "Clicks not incrementing"

**Root causes:**
1. Wrong column name (clicks vs click)
2. Not committing transaction
3. Query executed but not updated
4. Wrong shortCode being updated

**Debug:**
```javascript
// Check database directly
// sqlite3 shortener.db
// SELECT * FROM urls WHERE shortCode = 'test';
// Should show clicks incrementing

// Or in code:
console.log('Before:', db.query(...));
db.execute('UPDATE urls SET clicks = clicks + 1 WHERE...');
console.log('After:', db.query(...));
```

---
