# 🔗 Link Expiration System: Learn By Building

**"Build a secure link-sharing API that generates unique URLs that automatically expire after a certain number of clicks or a specific time limit."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User wants to share a Google Drive link, but only wants it to work for the next 24 hours.
2. User wants to share a link, but it should only work for the first 5 people who click it.
3. The server generates a short URL: `your-api.com/s/xY9z`.
4. Someone clicks the short URL. The server checks the limits.
5. If limits are okay, redirect them. If not, show "Link Expired".

**What data do you need for each?**

After thinking, here's the data model:

```
Links
├─ id (String - short, unique hash like 'xY9z')
├─ target_url (TEXT - Where the user actually wants to go)
├─ max_clicks (Integer - Optional)
├─ current_clicks (Integer - Defaults to 0)
├─ expires_at (Timestamp - Optional)
└─ created_at
```

---

### Step 2: The Concurrency Problem (Race Conditions)

**Question: How do you accurately count clicks if 100 people click the link at the exact same millisecond?**

**Bad Idea:**
```javascript
// Step 1: Read current clicks
const link = await db.query("SELECT current_clicks FROM links WHERE id = ?", id);

// Step 2: Add 1 in memory
const newClicks = link.current_clicks + 1;

// Step 3: Save to DB
await db.query("UPDATE links SET current_clicks = ? WHERE id = ?", [newClicks, id]);
```
*Why it's bad:* If 100 requests run Step 1 at the same time, they all read `current_clicks = 0`. They all calculate `0 + 1 = 1`. They all update the DB to `1`. You had 100 clicks, but the database says `1`.

**Good Idea (Atomic Updates):**
Make the database do the math. The database engine will process these one by one in a queue.

```sql
-- Step 1: Add 1 directly in the SQL engine
UPDATE links SET current_clicks = current_clicks + 1 WHERE id = 'xY9z';
```

---

### Step 3: The Redirection Mechanism

**Question: How does the server actually forward the user?**

When a user clicks `your-api.com/s/xY9z`, they are sending a GET request to your server. 
You must respond with an HTTP `302 Found` (or `301 Moved Permanently`) status code and a `Location` header pointing to the `target_url`.

```javascript
app.get('/s/:id', async (req, res) => {
  // ... check logic ...
  
  // Instruct the browser to immediately redirect
  res.redirect(302, link.target_url);
});
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Target URL Input                     │  │
│  │ "Expire after X clicks" Input        │  │
│  │ "Expire on Date" Input               │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP POST /api/links
        HTTP GET /s/:id (from end-users)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Validate Input URLs (Prevent      │  │
│  │    phishing/malware loops)           │  │
│  │ 2. Generate Nanoid                   │  │
│  │ 3. Handle /s/:id clicks:             │  │
│  │    - Check `expires_at`              │  │
│  │    - Check `current_clicks`          │  │
│  │    - Increment `current_clicks`      │  │
│  │    - Send 302 Redirect               │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent storage for links            │
└────────────────────────────────────────────┘
```
