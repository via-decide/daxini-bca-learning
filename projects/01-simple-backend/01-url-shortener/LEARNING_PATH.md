# 🔗 URL Shortener: Learn By Building

**"Build a system that takes long, ugly URLs and turns them into short, shareable links, tracking how many times they are clicked."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **HTTP Redirects** - The difference between 301 (Permanent) and 302 (Temporary) redirects.  
✅ **Fire-and-Forget Architecture** - Handling background tasks (analytics) without blocking the user response.  
✅ **String Encoding & Hashing** - Strategies for generating short, unique, collision-resistant identifiers.  
✅ **Database Indexing** - Why a `UNIQUE INDEX` is critical for lookup performance (O(1) vs O(N)).  
✅ **Data Validation** - Ensuring users only submit safe, valid HTTP/HTTPS URLs.  

---

## 📋 Project Overview

### The Problem

Long URLs are ugly, break in text messages, and are impossible to remember. Furthermore, marketers need to know exactly how many people clicked a link they shared on Twitter vs Facebook. 

**Your job:** Build the engine that powers Bitly.

### Who Uses It

```
The Creator:
├─ Pastes a long URL
├─ Gets a short URL
└─ Logs in later to see click analytics (IP, Browser, Time)

The Clicker:
├─ Clicks the short link
└─ Instantly gets redirected to the real destination
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Create a Short URL

```pseudocode
POST /api/shorten(original_url):
  Step 1: Validate input
    if not isValidHttpUrl(original_url):
      return error 400 "Invalid URL"
      
  Step 2: Generate Short Code
    code = nanoid(7) // generates 7 random chars
    
  Step 3: Save to Database
    try:
      // Fails if 'code' already exists due to UNIQUE constraint
      db.insert("urls", { original_url, short_code: code })
    catch constraint_error:
      // Collision happened! Very rare, but possible.
      // Generate a new code and try again.
      code = nanoid(7)
      db.insert("urls", { original_url, short_code: code })
      
  Step 4: Return result
    return { short_url: `https://mydomain.com/${code}` }
```

### 2. The Redirect Endpoint (The Core Feature)

```pseudocode
GET /:shortCode:
  Step 1: Lookup the URL
    // This MUST hit an index to be fast
    url = database.query("SELECT id, original_url FROM urls WHERE short_code = ?", shortCode)
    
    if not url:
      return 404 "Link not found"
      
  Step 2: Redirect Immediately
    // Send HTTP 302 to the browser right now
    HTTP_Response(302, Location: url.original_url)
    
  Step 3: Background Analytics (Do not await!)
    // Gather request data
    ip = request.headers['x-forwarded-for'] || request.ip
    user_agent = request.headers['user-agent']
    referrer = request.headers['referer']
    
    // Save to DB asynchronously
    database.execute("UPDATE urls SET clicks = clicks + 1 WHERE id = ?", url.id)
    database.insert("click_analytics", { url_id: url.id, ip, user_agent, referrer })
```

### 3. Fetch Analytics

```pseudocode
GET /api/urls/:id/analytics:
  Step 1: Fetch core stats
    url = database.query("SELECT * FROM urls WHERE id = ?", id)
    
  Step 2: Fetch recent clicks
    clicks = database.query("SELECT * FROM click_analytics WHERE url_id = ? ORDER BY clicked_at DESC LIMIT 50", id)
    
  Step 3: Return dashboard data
    return { url, recent_clicks: clicks }
```

---

## ✅ Before Submission

- [ ] API accepts a long URL and returns a short URL.
- [ ] API rejects invalid URLs (e.g., `not-a-url` or `ftp://...`).
- [ ] Visiting the short URL instantly redirects to the destination (HTTP 302).
- [ ] Database correctly tracks the total number of clicks.
- [ ] The redirect code does NOT `await` the database analytics inserts.
- [ ] The `short_code` column has a `UNIQUE INDEX` applied to it.
- [ ] Code is on GitHub.

**Success:** A high-performance redirect server capable of handling thousands of clicks per second.
